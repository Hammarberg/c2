/*
	c2 - cross assembler
	Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#include "c2a.h"
#include <algorithm>
#include <cstdarg>

#ifdef _MSC_VER
#include <malloc.h>
#define strcasecmp _stricmp
#endif

std::string escape_var(const char *pstr)
{
	return "";
}

std::string unescape_var(const char *pstr)
{
	return "";
}

uint16_t c2a::explicit_bitcount(const char *s)
{
	if(s[0] != '0' || !s[1])
		return 0;
	
	uint16_t bits = 0;
	
	if((s[1] == 'x' || s[1] == 'X') && s[2] == '0')
	{
		size_t size = strlen(&s[2]);
		bits = size > 1 ? uint16_t(size * 4) : 0;
	}
	else if((s[1] == 'b' || s[1] == 'B') && s[2] == '0')
	{
		size_t size = strlen(&s[2]);
		bits = size > 1 ? uint16_t(size * 1) : 0;
	}
	else if(s[1] == '0')
	{
		bits = uint16_t(strlen(&s[1]) * 3);
	}
	
	return bits;
}

static std::string &makelower(std::string &s)
{
	std::transform(s.begin(), s.end(), s.begin(),[](unsigned char c){ return std::tolower(c);});
	return s;
}

stok *c2a::maketok(const stok *t, const char *name, etype type, int16_t inord)
{
	stok *n = (stok *)alloc(sizeof(stok) + strlen(name) + 1);
	if(t)
	{
		memcpy(n, t, sizeof(stok));
	}
	n->type = type;
	strcpy(n->name, name);
	if(inord != -1)
		n->ord = inord;
	
	return n;
}

stok *c2a::clone(const stok *t)
{
	size_t s = sizeof(stok) + strlen(t->name) + 1;
	stok *n = (stok *)alloc(s);
	memcpy(n, t, s);
	n->root_labelindex = -1;
	n->scopeindex = -1;
	n->scopepos = -1;
	
	return n;
}
	
/*
static char *read_file(const char *file)
{
	FILE *fp=fopen(file, "r");
	if(!fp)
		return nullptr;

	fseek(fp, 0, SEEK_END);
	size_t size = ftell(fp);
	fseek(fp, 0, SEEK_SET);

	char *data = new char[size];
	fread(data, 1, size, fp);
	fclose(fp);
	
	return data;
}
*/

c2a::~c2a()
{
	/*
	for(auto i : macros)
	{
		std::vector<cmacro *> &v = i.second;
		
		for(size_t r=0; r<v.size(); r++)
		{
			delete v[r];
		}
	}
	*/
}

stok *c2a::get_next_nonspace(toklink &link, bool unlink)
{
	stok *o;
	
	for(;;)
	{
		o = link.pull_tok();
		if(!o)
			break;
			
		//printf("%s",o->format().c_str());
			
		if(unlink)
			link.unlink(o);
			
		if(o->type != etype::SPACE)
			break;
	}

	return o;
}

bool c2a::match_macro_parameters_pos_forward(int pos, const std::vector<stok *> &def, const std::vector<stok *> &par, int **idx, const int NUM_DEF, const int NUM_PAR)
{
	if(!NUM_DEF)
		return false;	// There is nothing to move
	
	stok *d = par[*idx[pos]];
	//printf("%s\n", d->name);
	int max = pos+1 < NUM_DEF ? *idx[pos+1] : NUM_PAR;
	for(int l = *idx[pos]+1; l < max; l++)
	{
		//printf("%s\n", par[l]->name);
		if(d->cmpi(par[l]))
		{
			*idx[pos] = l;
			return true;
		}
	}
	
	if(pos == NUM_DEF-1)
		return false;
		
	bool result = match_macro_parameters_pos_forward(pos+1, def, par, idx, NUM_DEF, NUM_PAR);
	
	if(result)
	{
		int start = pos > 0 ? *idx[pos-1]+1 : 0;
		max = pos+1 < NUM_DEF ? *idx[pos+1] : NUM_PAR;
		for(int l = start; l < max; l++)
		{
			//printf("%s\n", par[l]->name);
			if(d->cmpi(par[l]))
			{
				*idx[pos] = l;
				break;
			}
		}
	}
	
	return result;
};

bool c2a::match_macro_parameters(const std::vector<stok *> &def, const std::vector<stok *> &par, const std::vector<std::pair<std::string, std::vector<const char *>>> &inputs, std::vector<std::vector<stok *>> &outargs, std::vector<bool> &outisarray)
{
	/*
	printf("def: ");
	for(size_t r=0;r<def.size();r++)
		printf("%s", def[r]->format().c_str());
	printf("\n");
	
	printf("par: ");
	for(size_t r=0;r<par.size();r++)
		printf("%s", par[r]->format().c_str());
	printf("\n");
	*/
	const int NUM_RDEF = int(def.size());
	const int NUM_PAR = int(par.size());
	
	// Quick success or fail filtering for no parameters
	if(NUM_RDEF == 0)
		return NUM_PAR == 0;
	else
		if(NUM_PAR == 0)
			return false;
	
	// Calculate number of static operators (everything but variable parts) in macro parameter definition
	int set = 0;
	for(size_t r=0;r<def.size();r++)
	{
		stok *d = def[r];
		if(*d->name != '@' && *d->name != '~')
			set++;
	}
	
	const int NUM_DEF = set;

#ifndef _MSC_VER
	// Holds only static parameter indexes
	int *idx[NUM_DEF];
	// Same but also holds variables flagged with -1 or -2
	int ridx[NUM_RDEF];
#else
	int **idx = (int **)_alloca(sizeof(int *) * NUM_DEF);
	int *ridx = (int *)_alloca(sizeof(int) * NUM_RDEF);
#endif
	
	// Set initial positions
	set = 0;
	for(int r=0, l=0; r<NUM_RDEF; r++)
	{
		stok *d = def[r];
		
		// Not positioning variables now
		if(*d->name == '@')
		{
			ridx[r] = -1;
		}
		else if(*d->name == '~')
		{
			ridx[r] = -2;
		}
		else
		{
			idx[set] = &ridx[r];
			for(; l<NUM_PAR; l++)
			{
				if(d->cmpi(par[l]))
				{
					*idx[set] = l;
					l++;
					set++;
					break;
				}
			}
			if(l == NUM_PAR)
				break;
		}
	}
	if(set != NUM_DEF)
		return false;	//Failed setting initial positions, there can be no match

	for(;;)
	{
		bool results = true;
		
		outargs.clear();
		outisarray.clear();
		
		/*
		for(int l=0; l<NUM_RDEF; l++)
		{
			std::cout << ridx[l] << " ";
		}
		std::cout << "\n";
		
		int a = 5;
		*/
		
		// Methodical sanity checks here
		for(int l=0, v=0; l<NUM_RDEF; l++)
		{
			int cur = ridx[l];
			
			if(cur >= 0)
			{
				// First static parameter
				if(!l && cur != 0)
				{
					results = false;
					break;
				}
				
				// Last static parameter
				if(l == NUM_RDEF-1 && cur != NUM_PAR-1)
				{
					results = false;
					break;
				}
				
				// If next is a static parameter, make sure it's tiled to cur
				int next = l<NUM_RDEF-1 ? ridx[l+1] : -1;
				if(next >= 0)
				{
					if(next != cur+1)
					{
						results = false;
						break;
					}
				}
			}
			else
			{
				bool isarray = ridx[l] == -2;
				
				outargs.push_back(std::vector<stok *>());
				std::vector<stok *> &args = outargs[outargs.size()-1];
				
				// Sanity check potential argument
				int start = l ? ridx[l-1] + 1 : 0;
				int end = l<NUM_RDEF-1 ? ridx[l+1] : NUM_PAR;
				int count = end - start;

				// Match indexed variables
				const std::vector<const char *> &iv = inputs[v].second;
				if(iv.size())
				{
					if(count != 1)
					{
						results = false;
						break;
					}
					stok *d = par[start];
					
					for(size_t r=0; r<iv.size(); r++)
					{
						if(d->cmpi(iv[r]))
						{
							args.push_back(maketok(d, std::to_string(r).c_str(), etype::NUM));
							goto match;
						}
					}
					
					results = false;
					break;
					
					match:;
				}
				else
				{
					int bc = 0;
					for(;start<end;start++)
					{
						stok *d = par[start];
						bc += bracketcount(d);
						
						if(isarray == false && bc == 0 && *d->name == ',')
						{
							// Comma separation in non variable argument outside brackets
							results = false;
							break;
						}
						
						args.push_back(d);
						//std::cout << d->format().c_str();
					}
					//std::cout << "\n";
					
					if(bc)
					{
						// Uneven number of brackets
						results = false;
						break;
					}
				}
				
				outisarray.push_back(isarray);
				v++;
			}
		}
		
		if(results)
			break;	// Got a match
		
		// Iterate positions
		if(!results && !match_macro_parameters_pos_forward(0, def, par, idx, NUM_DEF, NUM_PAR))
		{
			// All combos covered and no match
			return false;
		}
	}
	
	return true;
}

bool c2a::match_macro(stok *io, toklink &link)
{
	stok *o = io;
	//printf("%s\n", o->name);
	std::string stmp = o->name;
	stmp = makelower(stmp);
	auto i = macros.find(stmp);
	if(i == macros.end())
	{
		return false;
	}
	
	std::vector<std::shared_ptr<cmacro>> &v = i->second;
	
	stok *pend = o = o->get_next_nonspace();
	
	std::vector<stok *> par;	// Collection of parameters after the possible macro name

	while(pend && pend->is_same_line(io))
	{
		par.push_back(pend);
		pend = pend->get_next_nonspace();
	}
	
	std::vector<std::vector<stok *>> outargs;
	std::vector<bool> outisarray;
		
	for(size_t r=0; r<v.size(); r++)
	{
		cmacro *m = v[r].get();
		//m->print();
		m->signature.restart();
		
		std::vector<stok *> def;  // Macro header definition
		
		stok *t = m->signature.pull_tok();
		while(t)
		{
			def.push_back(t);
			t = t->get_next();
		}
		
		if(match_macro_parameters(def, par, m->inputs, outargs, outisarray))
		{
			assert(outargs.size() == m->inputs.size());
			
			char ctmp[256];
			toklink out = link;
			out.restart(io->get_prev());

			// Push debug stack
			sprintf(ctmp, "\n{c2_scope_push(%d,%d);\n", int(io->fileindex), io->line);
			out.push_tok(maketok(io, ctmp, etype::ALPHA));
			
			//Prepare lambda header
			out.push_tok(maketok(io, "[&]("));
			for(size_t r=0;r<m->inputs.size();r++)
			{
				out.push_tok(maketok(io, "var "));
				out.push_tok(maketok(io, m->inputs[r].first.c_str(), etype::ALPHA));
				if(r != m->inputs.size() - 1)
					out.push_tok(maketok(io, ",", etype::OP));
			}
			out.push_tok(maketok(io, ")"));
			
			// Push current scope
			
			// Prepare macro link for streaming
			m->restart();
			
			// The first op from the macro should be '{', push it
			o = m->pull_tok();
			assert(o && *o->name == '{');
			stok *rpos,*apos;
			out.push_tok(rpos = clone(o));
			
			//Avoid some preprocessor directions
			rpos->line = io->line;
			rpos->fileindex = io->fileindex;
			
			out.push_tok(maketok(rpos, "c2_scope_internal_push", etype::ALPHA));
			out.push_tok(maketok(rpos, " ", etype::SPACE));
			
			out.push_tok(maketok(io, autolabel(io->name).c_str(), etype::ALPHA, 0));		//Forcing ord
			out.push_tok(maketok(io, ":", etype::OP, 1));
			
			// Push the rest of the macro
			while((o = m->pull_tok()))
			{
				out.push_tok(apos = clone(o));
			}
			
			// Restore namespace
			out.push_tok(maketok(io, "c2_namespace", etype::ALPHA));
			out.push_tok(maketok(io, " ", etype::SPACE));
			out.push_tok(maketok(io, parent_label.c_str(), etype::ALPHA));
			
			// Pop current scope
			out.push_tok(maketok(io, " ", etype::SPACE));
			out.push_tok(maketok(io, "c2_scope_internal_pop", etype::ALPHA));
			
			out.push_tok(maketok(io, "(", etype::OP));
			
			// Expand arguments into vars or arrays
			if(outargs.size())
			{
				//out.push_tok(maketok(io, "var", etype::ALPHA));
				//out.push_tok(maketok(io, " ", etype::SPACE));
					
				for(size_t t=0; t<outargs.size(); t++)
				{
					//out.push_tok(maketok(io, m->inputs[t].c_str(), etype::ALPHA));
					//out.push_tok(maketok(io, "=", etype::OP));
					
					std::vector<stok *> &args = outargs[t];
					
					bool isarray = outisarray[t];
					
					if(isarray)
						out.push_tok(maketok(io, "{", etype::OP));
					
					stok *anon_first = nullptr;
					stok *anon_last = nullptr;
					bool anon_valid = true;
					
					for(size_t r=0;r<args.size();r++)
					{
						stok *c = args[r];
						
						if(isarray && c->type == etype::QUOTE)
						{
							anon_valid = false;
							
							if(!isarray)
								out.push_tok(maketok(io, "{", etype::OP));
								
							char *p = c->name;
							bool f = true;
							while(*p)
							{
								if(!f)
								{
									out.push_tok(maketok(io, ",", etype::OP, 10));
								}
								
								char numtmp[64];
								sprintf(numtmp,"%d", int(*p));
								out.push_tok(maketok(io, numtmp, etype::NUM, 10));
								
								p++;
								f = false;
							}
							
							if(!isarray)
								out.push_tok(maketok(io, "}", etype::OP));
						}
						else
						{
							c = clone(c);
							out.push_tok(c);
							
							if(anon_valid && c->type == etype::OP && (*c->name == '+' || *c->name == '-'))
							{
								if(!anon_first)
									anon_first = c;
									
								anon_last = c;
							}
							else
							{
								anon_valid = false;
							}
						}
					}
					
					if(anon_valid)
					{
						anonymous.push_back(std::pair<stok *, stok *>(anon_first, anon_last));
					}
					
					if(isarray)
						out.push_tok(maketok(io, "}", etype::OP, 10));
						
					if(t != outargs.size() - 1)
						out.push_tok(maketok(io, ",", etype::OP));
				}
			}
			
			out.push_tok(maketok(io, ")", etype::OP));
			out.push_tok(maketok(io, ";", etype::OP));
			
			// Pop debug stack
			sprintf(ctmp, "c2_scope_pop();}\n");
			out.push_tok(maketok(io, ctmp, etype::ALPHA));
			
			//Clear macro call
			o = io;
			do
			{
				if(o->type != etype::SPACE)
					o->mute();
				o = o->get_next();
			}
			while(o != pend);
			
			// Restart the main link to the beginning of the expanded macro
			link.restart(rpos, link.get_end());
			
			return true;
		}
	}
	
	//Warn about nearly matched macro here
	warning(io, "\"%s\" looks like a macro but could not match any parameters", io->name);
	
	return false;
}

void c2a::parse_macro_body(toklink &in, toklink &out)
{
	for(;;)
	{
		stok *o = in.pull_tok();
		
		if(!o)
			error(o, "Unexpected end");
			
		out.push_tok(clone(o));
		
		switch(*o->name)
		{
			case '}':
				o->mute();
				return;
				break;
			case '{':
				o->mute();
				parse_macro_body(in, out);
				break;
			default:
				if(o->type != etype::SPACE)
					o->mute();
				break;
		}
	}
}

void c2a::parse_macro(toklink &link)
{
	std::vector<std::string> names;
	
	stok *o, *title;

	for(;;)
	{
		o = get_next_nonspace(link);
		
		if(o->type != etype::ALPHA)
			error(o, "Macro name expected");
			
		title = o;
		names.push_back(o->name);
		o->mute();
		
		stok *t = o->get_next_nonspace();

		if(*t->name != ',')
			break;

		t->mute();
		o = t;
	}
	
	toklink signature;
	std::string stmp,stmp2;
	//std::vector<std::string> inputs;
	std::vector<std::pair<std::string, std::vector<const char *>>> inputs;
	std::vector<const char *> indexed_parm;
	
	bool array = false;
	bool lastparam = false;
		
	for(;;)
	{
		o = get_next_nonspace(link);
		
		if(*o->name == '@')
		{
			indexed_parm.clear();
			
			if(lastparam)
				error(o, "Arguments needs separation");
			
			o->mute();
			o = get_next_nonspace(link);
			
			// Extract indexed parameters
			if(*o->name == '[')
			{
				o->mute();
				for(;;)
				{
					o = get_next_nonspace(link);
					if(!o->is_same_line(title))
					{
						error(o, "Expected closing ] following [ in indexed macro parameter list");
					}
					
					if(o->type == etype::ALPHA)
					{
						indexed_parm.push_back(linear_cstring(o->name));
						o->mute();
					}
					else if(*o->name == ',')
					{
						o->mute();
					}
					else if(*o->name == ']')
					{
						o->mute();
						o = get_next_nonspace(link);
						break;
					}

				}
			}
				
			if(o->type != etype::ALPHA)
				error(o, "Parameter name expected");
				
			if(array)
				error(o, "A variadic input must be last in the macro declaration");
				
			stmp = o->name;
				
			if(stmp.size() > 3 && stmp.substr(stmp.size() - 3) == "...")
			{
				stmp = stmp.substr(0, stmp.size() - 3);
				signature.push_tok(maketok(o, "~", etype::OP));
				array = true;
			}
			else
			{
				signature.push_tok(maketok(o, "@", etype::OP));
			}
			
			inputs.push_back(std::pair<std::string, std::vector<const char *>>(stmp, indexed_parm));
			
			o->mute();
			lastparam = true;
		}
		else
		{
			if(*o->name == '{')
			{
				break;
			}
			
			stmp2 = o->name;
			signature.push_tok(maketok(o, makelower(stmp2).c_str(), o->type));
			o->mute();
			lastparam = false;
		}
	}
	
	std::shared_ptr<cmacro> m = std::make_shared<cmacro>();
	m->signature = signature;
	m->inputs = inputs;
	std::string name;

	for(size_t r=0; r<names.size(); r++)
	{
		//Store macro ptrs here before parse
		name = makelower(names[r]);
		auto i = macros.find(name);
		
		if(i == macros.end())
		{
			macros[name].push_back(m);
		}
		else
		{
			std::vector<std::shared_ptr<cmacro>> &v = i->second;
			
			for(size_t r=0; r<v.size(); r++)
			{
				if(v[r]->signature == signature)
				{
					error(title, "Macro already defined");
				}
			}
			
			i->second.push_back(m);
		}
	}
	
	link.unlink(o);
	m->push_tok(o);	//Push {
	//m->push_tok(makeprefix(o));
	parse_macro_body(link, *m);
}

void c2a::s_parse0(toklink &link)
{
	int bracket_count = 0;
	std::string stmp;
	
	for(;;)
	{
		stok *o = get_next_nonspace(link);
		if(!o)
			error(o, "Unexpected end of file");
			
		//stok *op[3] = {o->get_prev_nonspace(), o, o->get_next_nonspace()};
		
		//printf("%s",o->name);
		//fflush(stdout);
		
		if(o->type == etype::OP)
		{
			switch(*o->name)
			{
				case '#':
				{
					if(o->ord == 0)
					{
						//Kill line
						stok *n = o;
						while(o->is_same_line(n))
						{
							if(n->type != etype::SPACE)
								n->mute();
							
							n = n->get_next();
							if(!n)
								error(o, "Unexpected end of file");
						}
					}
				}
				break;
				case '{':
				{
					bracket_count++;
				}
				break;
				case '}':
				{
					bracket_count--;
					if(bracket_count < 0)
						error(o, "Unexpected '}'");
					
					if(!bracket_count)
					{
						return;
					}
				}
				break;
				default:
				break;
			}
		}
	}
}


void c2a::s_parse1(toklink &link)
{
	std::string stmp;
	bool label_declared;
	
	for(;;)
	{
		stok *o = get_next_nonspace(link);
		
		if(!o)
			return;
			
		stok *op[3] = {o->get_prev_nonspace(), o, o->get_next_nonspace()};
		//printf("%s", o->format().c_str());
		//fflush(stdout);
		
		if(o->ord == 0)
			label_declared = false;
		
		o->label_declared = label_declared ? 1 : 0;
		
		// Default labelindex unless we have explicitly specified otherwise
		if(o->root_labelindex == uint32_t(-1))
			o->root_labelindex = root_labelindex;
			
		if(o->scopeindex == uint32_t(-1))
			o->scopeindex = scopeindex;
			
		if(o->scopepos == uint32_t(-1))
			o->scopepos = uint32_t(scope_labels[scopeindex].size() - 1);
			
		switch(o->type)
		{
			case etype::ALPHA:
			{
				if(!strcasecmp("c2_namespace", o->name))
				{
					if(op[2]->type != etype::ALPHA)
						error(o, "A label is expected after c2_namespace");
					
					auto i = labelmap.find(op[2]->name);
					if(i == labelmap.end())
					{
						error(o, "Undeclared namespace");
					}
					
					root_labelindex = i->second.root_labelindex;
					parent_label = root_labels[root_labelindex].first;
					
					o->mute();
					op[2]->mute();
				}
				else if(!strcasecmp("c2_scope_internal_push", o->name))
				{
					scope_stack.push_back(scopeindex);
					scopeindex = int32_t(scope_labels.size());
					scope_labels.push_back(std::vector<const char *>());
					o->mute();
				}
				else if(!strcasecmp("c2_scope_internal_pop", o->name))
				{
					scopeindex = scope_stack.back();
					scope_stack.pop_back();
					o->mute();
				}
				else if(!strcasecmp("macro", o->name))
				{
					o->mute();
					parse_macro(link);
				}
				else if(!strcasecmp("var", o->name))
				{
					//Force lowercase or name
					strcpy(o->name, "var");
					
					if(o->ord == 0 || label_declared)
					{
						//Slap on ;
						stok *n = o;
						while(o->is_same_line(n))
						{
							n = n->get_next();
							if(!n)
								error(o, "Unexpected end of file");
						}
						
						link.link(maketok(o, ";"), n->get_prev_nonspace());
					}
				}
				else if((o->ord == 0 || label_declared) && match_macro(o, link))
				{
					// Macro expanded, nothing to do here
				}
			}
			break;
			case etype::OP:
			{
				switch(*o->name)
				{
					case '@':
					{	
						if((o->ord == 0 || label_declared) && *op[2]->name == '=')
						{
							bool multiple = false;
							int bc = 0;
							stok *n = o;
							while(o->is_same_line(n = n->get_next()))
							{
								if(!n)
									error(o, "Unexpected end of file");
								
								bc += bracketcount(n);
								
								if(bc == 0 && *n->name == ',')
								{
									multiple = true;
								}
							}
							
							if(bc)
								error(o, "@ assignment error");

							if(multiple)
							{
								// Wrap arguments
								link.link(maketok(o, "{"), op[2]);
								link.link(maketok(o, "};"), n->get_prev_nonspace());
							}
							else
							{
								link.link(maketok(o, ";"), n->get_prev_nonspace());
							}
						}
						
						stok *after = o->get_prev();
						link.unlink(o);
						link.link(maketok(o, "c2_org", etype::ALPHA), after);
					}
					break;
					case '%':
					{	
						if(op[0]->type != etype::NUM && op[0]->type != etype::ALPHA && op[2]->type == etype::NUM)
						{
							// Handle binary prefix
							o->mute();

							char tmp[256] = "0b";
							strcpy(tmp+2, op[2]->name);
							
							link.link(maketok(op[2], tmp, etype::NUM), o);
							
							op[2]->mute();
						}
					}
					break;
					case ':':
					{
						if(*o->get_next()->name != ':')	//Avoid C++ namespaces
						{
							bool indexed_label = false;
							stok *plabel = nullptr;
							switch(o->ord)
							{
								case 0:
								{
									//unnamed label
									stmp = autolabel("noname", true);
									plabel = o;
								}
								break;
								case 1:
								{
									if(op[0]->type == etype::ALPHA)
									{
										stmp = op[0]->name;
										plabel = op[0];
									}
								}
								break;
								default:
								{
									// Handle label[x]:
									if(*op[0]->name == ']')
									{
										stok *p = op[0]->get_prev();
										
										int index_count = 1;
										
										while(index_count)
										{
											switch(*p->name)
											{
												case ']':
													index_count++;
													break;
												case '[':
													index_count--;
													break;
												default:
													break;
											}
											p = p->get_prev();
											if(!p)
												error(o, "Unexpected ']'");
										}
										
										if(p->ord == 0 && p->type == etype::ALPHA)
										{
											stmp = p->name;
											plabel = p;
											indexed_label = true;
										}
									}
								}
								break;
							}
							
							if(plabel)
							{
								//printf("label %s\n", stmp.c_str());
								
								// label detected
								bool local = false;
								std::string mapname;
								if(stmp[0] == '.')
								{
									local = true;
									mapname = parent_label + stmp;
									stmp = stmp.substr(1);
								}
								else
								{
									mapname = stmp;
								}
								
								auto i = labelmap.find(mapname);
								if(i == labelmap.end())
								{
									std::string s2;
									stok *psub = nullptr;
									const char *pstring = linear_string(mapname);
									
									if(local)
									{
										// Local label setup
										clabel &cr = *root_labels[root_labelindex].second;
										
										s2 = "c2i::var " + stmp + "={\"" + mapname + "\",0};\n";
										cr.sub = link.link(maketok(psub, s2.c_str()), cr.sub);
										
										stok *c;
										if(o->ord < 2)
										{
											s2 = mapname + "=c2_org;";
											link.link(c=maketok(plabel, s2.c_str()), plabel->get_prev());
										}
										else
										{
											link.link(c=maketok(plabel, mapname.c_str()), plabel->get_prev());
											link.link(maketok(plabel, "=c2_org;"), o->prev);
										}
										
										labelmap[mapname] = clabel(c, root_labelindex);
									}
									else
									{
										// Root label setup
										std::string subname = "c2_sub_s" + mapname;
										
										s2 = "struct c2_sub_s" + mapname + " {\n";
										psub = linkinit(maketok(o, s2.c_str()), link);
										
										s2 = "};\n";
										linkinit(maketok(o, s2.c_str()), link);
										
										s2 = "c2_basevar<" + subname + "> " + stmp + "={\"" + mapname + "\",0};\n";
										linkinit(maketok(o, s2.c_str()), link);
										
										stok *c;
										if(o->ord < 2)
										{
											s2 = mapname + "=c2_org;";
											link.link(c=maketok(plabel, s2.c_str()), plabel->get_prev());
										}
										else
										{
											link.link(c=maketok(plabel, mapname.c_str()), plabel->get_prev());
											link.link(maketok(plabel, "=c2_org;"), o->prev);
										}
										
										if(!indexed_label)
										{
											parent_label = mapname;
											root_labelindex = uint32_t(root_labels.size());
											clabel &cr = labelmap[mapname] = clabel(c, root_labelindex, psub);
											root_labels.push_back(std::pair<const char *, clabel *>(pstring, &cr));
										}
										else
										{
											labelmap[mapname] = clabel(c, root_labelindex);
										}
									}
										
									if(indexed_label)
									{
										stok *after = link.link(maketok(plabel, autolabel("idx", true).c_str(), etype::ALPHA, 0), o);
										link.link(maketok(plabel, ":", etype::OP, 1), after);
									}
									else
									{
										scope_labels[scopeindex].push_back(pstring);
									}
								}
								else
								{
									if(indexed_label)
									{
										link.link(maketok(plabel, mapname.c_str()), plabel->get_prev());
										link.link(maketok(plabel, "=c2_org;"), o->prev);
											
										stok *after = link.link(maketok(plabel, autolabel("idx", true).c_str(), etype::ALPHA, 0), o);
										link.link(maketok(plabel, ":", etype::OP, 1), after);
									}
									else
									{
										error(o, "Label already declared");
									}
								}
								
								// Remove label and/or ':'
								link.unlink(plabel);
								if(o != plabel)
									link.unlink(o);
								
								o = nullptr;
								label_declared = true;
								
							}
						}
					}
					break;
					default:
					break;
				};
			}
			break;
			case etype::NUM:
			{
				if(o->name[0] == '$')
				{
					stok *n = (stok *)alloc(sizeof(stok) + strlen(o->name) + 2);
					memcpy(n, o, sizeof(stok));
					strcpy(n->name, "0x");
					strcpy(n->name + 2, &o->name[1]);
					
					link.unlink(o);
					link.link(n, o->get_prev());
					o = n;
				}
				
				//printf("num %s\n", o->name);
				
				uint16_t bits = explicit_bitcount(o->name);
				
				if(bits)
				{
					char tmp[64];
					sprintf(tmp, "var(%s,%d)", o->name, bits);
					stok *n = maketok(o, tmp);
					link.unlink(o);
					link.link(n, o->get_prev());
				}
			}
			break;
			default:
			break;
		};
	}
}

void c2a::s_parse2(toklink &link)
{
	std::string stmp;
	//bool label_declared;
	
	uint16_t fileindex = 0;
	uint32_t line = 0;
							
	for(;;)
	{
		stok *o;
		
		for(;;)
		{
			o = link.pull_tok();
			if(!o)
				break;
				
			if(o->type != etype::SPACE)
			{
				break;
			}
			else if(*o->name == '\n')
			{
				line++;
			}
		}
		
		if(!o)
			break;
		
		// Fixup preprocessor line and file markers
		//printf("\"%s\" line %d fileindex %d\n", o->name, line, fileindex);
		
		if(o->fileindex != fileindex || o->line != line)
		{
			fileindex = o->fileindex;
			line = o->line;
			preprocessprefix(o, link);
		}
		
		//label_declared = o->label_declared == 1;
		
		switch(o->type)
		{
			case etype::ALPHA:
			{
				if(!strcmp("goto", o->name))
				{
					//Handle C goto
					stok *next = o->get_next_nonspace();
					
					auto i = labelmap.find(next->name);
					if(i == labelmap.end())
					{
						error(o, "goto label not found");
					}
					
					std::string label = autolabel("goto");
					
					link.link(maketok(next, label.c_str()), next);
					next->mute();
					
					label += ": ";
					stok *lablink = i->second.pos->get_prev();
					link.link(maketok(lablink, label.c_str()), lablink);
				}
				else if(*o->name == '.')
				{
					stok *prev = o->get_prev_nonspace();
					
					if(*prev->name == ')')
					{
						// For cases of f().name
						break;
					}
					
					stmp = root_labels[o->root_labelindex].first;
					stmp += o->name;
					
					auto i = labelmap.find(stmp);
					if(i != labelmap.end())
					{
						link.link(maketok(o, stmp.c_str()), o);
						o->mute();
					}
				}
			}
			break;
			/*
			case etype::OP:
			{
				switch(*o->name)
				{
					default:
					break;
				};
			}
			break;
			*/
			default:
			break;
		};
	}
	
	// Set anonymous references
	for(size_t r=0; r<anonymous.size(); r++)
	{
		stok *first = anonymous[r].first;
		stok *last = anonymous[r].second;
		
		bool start = true;
		int32_t offset = int32_t(first->scopepos);
		
		for(stok *p = first;;p = p->get_next())
		{
			if(*p->name == '-')
			{
				if(start)
				{
					start = false;
				}
				else
				{
					offset--;
				}
			}
			else if(*p->name == '+')
			{
				if(start)
				{
					start = false;
				}
				
				offset++;
			}
			
			p->mute();
			
			if(p == last)
				break;
		}
		
		if(offset < 0 || size_t(offset) >= scope_labels[first->scopeindex].size())
		{
			error(first, "Anonymous reference beyond scope");
		}
		
		link.link(maketok(first, scope_labels[first->scopeindex][offset]), first);
	}
}

void c2a::c_parse(toklink &link)
{
	std::string stmp;
	for(;;)
	{
		stok *o = link.pull_tok();
		
		if(!o)
			break;
			
		if(o->type == etype::ALPHA && o->ord == 0)
		{
			if(!strcmp("C2_SECTION_TOP", o->name))
			{
				if(c2_top)
					error(o, "Only one C2_SECTION_TOP block allowed");

				c2_top = o;
				o->mute();
			}
			else if(!strcmp("C2_SECTION_ASM", o->name))
			{
				if(c2_asm)
					error(o, "Only one C2_SECTION_ASM block allowed");
					
				if(!c2_top)
					error(o, "C2_SECTION_TOP is required before C2_SECTION_ASM");
				
				stok *n = o->get_next_nonspace();
				if(*n->name != '{')
					error(o, "Expected '{' after C2_SECTION_ASM");
					
				o->mute();
				c2_asm = n;
				break;
			}
		}
	}
	
	if(!c2_asm)
		error(nullptr, "Missing C2_SECTION_ASM");
		
	//Insert a default root label
	stok *after = c2_asm;
	after = link.link(maketok(c2_asm, "\n", etype::SPACE, -1), after);
	after = link.link(maketok(c2_asm, autolabel("root").c_str(), etype::ALPHA, 0), after);
	after = link.link(maketok(c2_asm, ":", etype::OP, 1), after);
	after = link.link(maketok(c2_asm, "\n", etype::SPACE, 2), after);
	
	s_parse0(link);
	c2_end = link.pull_tok();
	
	link.restart(c2_asm, c2_end);
	s_parse1(link);
	
	link.restart(c2_asm, c2_end);
	s_parse2(link);
}

void c2a::process(const char *infile, const char *outfile)
{
	tokline in(*this, files);
	in.load(infile);
	
	toklink link;
	
	stok *o;
	while((o = in.pull_tok()) != nullptr)
		link.push_tok(o);

	link.restart();
	c_parse(link);
	
	tokoutfile write(outfile);
	
	printf("\n---------------------------------------\n");

	link.restart();
	while((o = link.pull_tok()) != nullptr)
	{
		//printf("%s",o->name);
		//fflush(stdout);
		write.push_tok(o);
	}
}

void c2a::error(stok *o, const char *format, ...)
{
	static char errbuf[512];
	char tmp[256];
	
	va_list args;
	va_start (args, format);
	vsnprintf (tmp, sizeof(tmp), format, args);
	va_end (args);
	
	if(o)
	{
		sprintf(errbuf, "%s:%d: error: %s", files[o->fileindex].c_str(), o->line, tmp);
	}
	else
	{
		sprintf(errbuf, "error: %s", tmp);
	}
	
	throw errbuf;
}

void c2a::warning(stok *o, const char *format, ...)
{
	char tmp[256];
	
	va_list args;
	va_start (args, format);
	vsnprintf (tmp, sizeof(tmp), format, args);
	va_end (args);
	
	if(o)
	{
		fprintf(stderr, "%s:%d: warning: %s", files[o->fileindex].c_str(), o->line, tmp);
	}
	else
	{
		fprintf(stderr, "warning: %s", tmp);
	}
}
