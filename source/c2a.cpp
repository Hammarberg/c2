/*
	c2 - cross assembler
	Copyright (C) 2022-2024  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#include "c2a.h"
#include "log.h"
#include <algorithm>
#include <cstdarg>

#ifdef _WIN32
#include <malloc.h>
#define strcasecmp _stricmp
#endif

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
	
c2a::~c2a()
{
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

int64_t c2a::bracketcount(int64_t bc, const stok *o)
{
	char c = *o->name;
	
	switch(c)
	{
		case '(':
			return (bc+3)*2;
		case '{':
			return (bc+5)*2;
		case '[':
			return (bc+7)*2;
		case ')':
			return (bc/2)-3;
		case '}':
			return (bc/2)-5;
		case ']':
			return (bc/2)-7;
	};
	
	return bc;
}

int64_t c2a::rbracketcount(int64_t bc, const stok *o)
{
	char c = *o->name;
	
	switch(c)
	{
		case ')':
			return (bc+3)*2;
		case '}':
			return (bc+5)*2;
		case ']':
			return (bc+7)*2;
		case '(':
			return (bc/2)-3;
		case '{':
			return (bc/2)-5;
		case '[':
			return (bc/2)-7;
	};
	
	return bc;
}

std::string c2a::autolabel(const char *hint, bool local)
{
	std::string out = local ? ".c2_auto_" : "c2_auto_";
	if(hint)
	{
		// Get rid of dots in hint
		while(*hint)
		{
			if(*hint == '.')
				out += '_';
			else
				out += *hint;
			
			hint++;
		}
		
		out += "_";
	}
	out += std::to_string(auto_num++);
	return out;
}

stok *c2a::preprocessprefix(stok *o, toklink &link)
{
	stok *n = o->get_prev();
	while(o->is_same_line(n))
	{
		n = n->get_prev();
	}
	
	char tmp[1024];
	if(*n->name == 0x0a)
		snprintf(tmp, sizeof(tmp), "# %d \"%s\"\n", o->line, files[o->fileindex].c_str());
	else
		snprintf(tmp, sizeof(tmp), "\n# %d \"%s\"\n", o->line, files[o->fileindex].c_str());

	link.link(maketok(o, tmp), n);
	return n;
}

stok *c2a::linkinit(stok *p, toklink &out)
{
	out.link(p, c2_top);
	return c2_top = p;
}

bool c2a::match_macro_parameters_pos_forward(int pos, const std::vector<stok *> &def, const std::vector<stok *> &par, std::vector<int *> &idx, const int NUM_DEF, const int NUM_PAR)
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
	if(verbose >= 6)
	{
		fprintf(stderr, "def: ");
		for(size_t r=0;r<def.size();r++)
			fprintf(stderr, "%s", def[r]->format().c_str());
		fprintf(stderr, "\n");

		fprintf(stderr, "par: ");
		for(size_t r=0;r<par.size();r++)
			fprintf(stderr, "%s", par[r]->format().c_str());
		fprintf(stderr, "\n");
	}

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

	// Holds only static parameter indexes
	std::vector<int *> idx(NUM_DEF);
	// Same but also holds variables flagged with -1 or -2
	std::vector<int> ridx(NUM_RDEF);
	
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
	{
		info(6, nullptr, "Failed setting initial positions\n");
		return false;	//Failed setting initial positions, there can be no match
	}

	for(;;)
	{
		if(verbose >= 6)
		{
			fprintf(stderr, "ridx:");
			for(size_t r=0;r<NUM_RDEF;r++)
				fprintf(stderr, " %d", ridx[r]);
			fprintf(stderr, "\n");

			fprintf(stderr, "idx:");
			for(size_t r=0;r<NUM_DEF;r++)
				fprintf(stderr, " %d", *idx[r]);
			fprintf(stderr, "\n");
		}

		bool results = true;
		
		outargs.clear();
		outisarray.clear();
		
		// Methodical sanity checks here
		for(int l=0, v=0; l<NUM_RDEF; l++)
		{
			int cur = ridx[l];
			
			if(cur >= 0)
			{
				// First static parameter
				if((!l && cur) || (l && !cur))
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
				bool isarray = cur == -2;
				
				// Sanity check potential argument
				int start = l ? ridx[l-1] + 1 : 0;
				int end = l<NUM_RDEF-1 ? ridx[l+1] : NUM_PAR;
				//int count = end - start;

				outargs.push_back({});
				std::vector<stok *> &args = outargs[outargs.size()-1];

				// Indexed variables
				const std::vector<const char *> &iv = inputs[v].second;

				int64_t bc = 0;
				for(;start<end;start++)
				{
					stok *d = par[start];
					bc = bracketcount(bc, d);

					if(!isarray && !iv.size())
					{
						if(bc == 0 && *d->name == ',')
						{
							// Comma separation in non variable argument outside brackets
							results = false;
							break;
						}
					}
					else
					{
						if(iv.size())
						{
							if(bc)
							{
								results = false;
								break;
							}

							if(*d->name != ',')
							{
								for(size_t r=0; r<iv.size(); r++)
								{
									if(d->cmpi(iv[r]))
									{
										d = maketok(d, std::to_string(r).c_str(), etype::NUM);
										goto match;
									}
								}
								results = false;
								break;

								match:;
							}
						}
					}
					args.push_back(d);
				}

				if(bc || args.size() == 0)
				{
					// Uneven number of brackets or no argument
					results = false;
					break;
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
	info(6, o, "Testing macro %s\n", o->name);
	std::string stmp = o->name;
	stmp = makelower(stmp);
	auto i = macros.find(stmp);
	if(i == macros.end())
	{
		return false;
	}
	
	info(5, o, "Matching macro %s\n", o->name);

	auto &v = i->second;
	
	stok *pend = o = o->get_next_nonspace();
	
	std::vector<stok *> par;	// Collection of parameters after the possible macro name

	while(pend && pend->is_same_line(io))
	{
		par.push_back(pend);
		pend = pend->get_next_nonspace();
	}
	
	std::vector<std::vector<stok *>> outargs;
	std::vector<bool> outisarray;

	bool disabled_detected = false;
		
	for(auto mi = v.rbegin(); mi != v.rend(); mi++)
	{
		cmacro *m = mi->second.get();
		//m->print();
		m->signature.restart();
		
		std::vector<stok *> def;  // Macro header definition
		
		stok *t = m->signature.pull_tok();
		while(t)
		{
			def.push_back(t);
			t = t->get_next();
		}

		if(m->disablecount)
		{
			disabled_detected = true;
		}
		else if(match_macro_parameters(def, par, m->inputs, outargs, outisarray))
		{
			assert(outargs.size() == m->inputs.size());

			stok *rpos = nullptr;
			toklink out = link;
			out.restart(io->get_prev());

			if(m->implementation.empty())
			{
				m->implementation = autolabel(io->name);

				//Prepare function pointer
				linkinit(maketok(io, "std::function<void("), link);
				for(size_t r=0;r<m->inputs.size();r++)
				{
					linkinit(maketok(io, "var"), link);
					if(r != m->inputs.size() - 1)
						linkinit(maketok(io, ",", etype::OP), link);
				}
				linkinit(maketok(io, ")> "), link);
				linkinit(maketok(io, m->implementation.c_str()), link);
				linkinit(maketok(io, ";\n"), link);

				// Generate macro lambda
				out.push_tok(maketok(io, m->implementation.c_str()));
				out.push_tok(maketok(io, "=[&]("));
				for(size_t r=0;r<m->inputs.size();r++)
				{
					out.push_tok(maketok(io, "var "));
					out.push_tok(maketok(io, m->inputs[r].first.c_str(), etype::ALPHA));
					if(r != m->inputs.size() - 1)
						out.push_tok(maketok(io, ",", etype::OP));
				}
				out.push_tok(maketok(io, ")"));

				// Prepare macro link for streaming
				m->restart();

				// The first op from the macro should be '{', push it
				o = m->pull_tok();
				assert(o && *o->name == '{');
				out.push_tok(rpos = clone(o));

				//Avoid some preprocessor directions
				rpos->line = io->line;
				rpos->fileindex = io->fileindex;

				out.push_tok(maketok(rpos, "c2_scope_internal_push", etype::ALPHA));
				out.push_tok(maketok(rpos, " ", etype::SPACE));

				//Disable the macro for re-reference, restored at c2_scope_internal_pop
				m->disablecount++;
				macro_stack.push_back(m);

				out.push_tok(maketok(io, autolabel("macro").c_str(), etype::ALPHA, 0));		//Forcing ord
				out.push_tok(maketok(io, ":", etype::OP, 1));

				// Push the rest of the macro
				while((o = m->pull_tok()))
				{
					out.push_tok(clone(o));
				}

				// Restore namespace
				out.push_tok(maketok(io, "c2_namespace", etype::ALPHA));
				out.push_tok(maketok(io, " ", etype::SPACE));
				out.push_tok(maketok(io, parent_label.c_str(), etype::ALPHA));

				// Pop current scope
				out.push_tok(maketok(io, " ", etype::SPACE));
				out.push_tok(maketok(io, "c2_scope_internal_pop", etype::ALPHA));

				out.push_tok(maketok(io, ";", etype::OP));
			}

			// Call lambda
			out.push_tok(maketok(io, m->implementation.c_str()));

			// Set restart pos if not already set
			if(!rpos)
				rpos = out.get_pos();

			out.push_tok(maketok(io, "(", etype::OP));

			// Expand arguments into vars or arrays
			if(outargs.size())
			{
				for(size_t t=0; t<outargs.size(); t++)
				{
					std::vector<stok *> &args = outargs[t];
					
					bool isarray = outisarray[t];
					
					if(isarray)
						out.push_tok(maketok(io, "{", etype::OP));
					
					stok *anon_first = nullptr;
					stok *anon_last = nullptr;
					bool anon_valid = args.size() != 0;
					
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
								snprintf(numtmp, sizeof(numtmp), "%d", int(*p));
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
						anonymous.push_back({anon_first, anon_last});
					}
					
					if(isarray)
						out.push_tok(maketok(io, "}", etype::OP, 10));
						
					if(t != outargs.size() - 1)
						out.push_tok(maketok(io, ",", etype::OP));
				}
			}
			
			out.push_tok(maketok(io, ")", etype::OP));
			out.push_tok(maketok(io, ";", etype::OP));
			
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

	if(disabled_detected)
	{
		error(io, "Recursive macro");
	}
	
	//Warn about nearly matched macro here
	warning(io, "\"%s\" looks like a macro but could not match any parameters\n", io->name);
	
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
	
	stok *o, *title = nullptr;

	o = get_next_nonspace(link);

	for(;;)
	{
		if(!o)
			error(o, "Unexpected end of file");

		if(*o->name != ',')
		{
			if(o->type == etype::SPACE)
			{
				if(!names.size())
					error(o, "Invalid macro name");

				o->mute();
				break;
			}

			if(o->type != etype::ALPHA)
				error(o, "Macro name expected");

			if(!title)
				title = o;

			names.push_back(o->name);
			o->mute();
		}

		o->mute();
		o = o->get_next();
	}
	
	toklink signature;
	std::string stmp,stmp2;
	//std::vector<std::string> inputs;
	std::vector<std::pair<std::string, std::vector<const char *>>> inputs;
	std::vector<const char *> indexed_parm;
	
	bool array = false;
	bool lastparam = false;
	
	// Offset signature count with enum parameters
	int signature_offset = 0;
		
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
				signature_offset++;
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
			
			inputs.push_back({stmp, indexed_parm});
			
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
			macros[name].insert({signature.count()+signature_offset, m});
		}
		else
		{
			auto &v = i->second;
			
			for(auto mi = v.begin(); mi != v.end(); mi++)
			{
				if(mi->second->cmp(*m.get()))
				{
					error(title, "Macro already defined");
				}
			}
			
			i->second.insert({signature.count()+signature_offset, m});
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
	auto insert_slix=[this, &link](stok *o)
		{
			size_t scopelix_stack_size = scopelix_stack.size();
			if(!scopelix_stack_size)
			{
				// Should never happen
				error(o, "Attemped assembly outside any scope");
			}

			sslix &slix=scopelix_stack[scopelix_stack_size-1];

			if(!slix.implemented)
			{
				VERBOSE(6, "slix %p\n",slix.start);

				// Push debug stack and scope label index
				slix.implemented = true;
				slix.slix = scopelix;

				char ctmp[256];
				snprintf(ctmp, sizeof(ctmp), "c2_sscope c2_scope(%d,%d,%d);", int(slix.start->fileindex), slix.start->line, int(scopelix));
				link.link(maketok(slix.start, ctmp), slix.start);

				scopelix++;
			}
		};

	std::string stmp;
	bool label_declared = false;
	
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
					scope_labels.push_back({});
					o->mute();
				}
				else if(!strcasecmp("c2_scope_internal_pop", o->name))
				{
					scopeindex = scope_stack.back();
					scope_stack.pop_back();
					o->mute();
					cmacro *m = macro_stack.back();
					macro_stack.pop_back();
					m->disablecount--;

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
						
						link.link(maketok(o, ";", etype::OP), n->get_prev_nonspace());
					}
				}
				else if((o->ord == 0 || label_declared) && match_macro(o, link))
				{
					// Make sure the scope is set up
					insert_slix(o);
					info(6, o, "Expanded macro\n");
				}
				else
				{
					info(6, o, "No expansion\n");
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
							int64_t bc = 0;
							stok *n = o;
							while(o->is_same_line(n = n->get_next()))
							{
								if(!n)
									error(o, "Unexpected end of file");
								
								bc = bracketcount(bc, n);
								
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
								link.link(maketok(o, "{", etype::OP), op[2]);
								stok *ta = link.link(maketok(o, "}", etype::OP), n->get_prev_nonspace());
								link.link(maketok(o, ";", etype::OP), ta);
							}
							else
							{
								link.link(maketok(o, ";", etype::OP), n->get_prev_nonspace());
							}
						}
						
						stok *after = o->get_prev();
						link.unlink(o);
						link.link(maketok(o, "c2_org", etype::ALPHA), after);
					}
					break;
					case '%':
					{	
						if(op[0]->type != etype::NUM && 
							op[0]->type != etype::ALPHA && 
							*op[0]->name != ')' && 
							*op[0]->name != ']' && 
							op[2]->type == etype::NUM)
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
								// Scope
								insert_slix(plabel);

								// label detected
								bool local = false;
								std::string root_mapname, mapname;
								
								// Handle ..label
								int numdots = 0;
								while(stmp[numdots] == '.')
									numdots++;
								
								if(numdots)
								{
									local = true;
									
									stmp = stmp.substr(numdots);
									
									mapname = root_mapname = root_labels[root_labelindex - (numdots - 1)].first ;
									mapname += "." + stmp;
								}
								else
								{
									mapname = root_mapname = stmp;
								}
								
								VERBOSE(6, "Label %s\n", mapname.c_str());
								
								auto i = labelmap.find(mapname);
								if(i == labelmap.end())
								{
									auto init_subspace = [this](toklink &link, const std::string &mapname, bool macrospace)->stok*
									{
										std::string s2, subname = "c2_sub_s" + mapname;

										s2 = "struct " + subname + " {\n";
										stok *psub = linkinit(maketok(link.get_pos(), s2.c_str()), link);

										if(macrospace)
										{
											s2 = "}"+mapname+";\n";
										}
										else
										{
											s2 = "};\n";
										}

										linkinit(maketok(link.get_pos(), s2.c_str()), link);

										return psub;
									};

									std::string s2;
									const char *pstring = linear_string(mapname);
									
									if(local)
									{
										// Local label setup
										clabel &cr = *root_labels[root_labelindex - (numdots - 1)].second;

										if(!cr.sub)
										{
											cr.sub = init_subspace(link, root_mapname, true);
										}
										
										s2 = "c2i::var " + stmp + "=c2_slabel(\"" + mapname + "\",0);\n";
										cr.sub = link.link(maketok(cr.sub, s2.c_str()), cr.sub);
										
										stok *c;
										if(o->ord < 2)
										{
											s2 = mapname + "[c2_lix]=c2_org;";
											link.link(c=maketok(plabel, s2.c_str()), plabel->get_prev());
										}
										else
										{
											link.link(c=maketok(plabel, mapname.c_str()), plabel->get_prev());
											link.link(maketok(plabel, "[c2_lix]=c2_org;"), o->prev);
										}
										
										labelmap[mapname] = clabel(c, root_labelindex - (numdots - 1));
									}
									else
									{
										// Root label setup
										stok *psub = nullptr;

										bool macrospace = mapname.size() >= 14 && mapname.substr(0, 14) == "c2_auto_macro_";

										stok *c = nullptr;
										if(!macrospace)
										{
											psub = init_subspace(link, mapname, false);

											std::string subname = "c2_sub_s" + mapname;

											s2 = "c2_basevar<" + subname + "> " + stmp + "=c2_slabel(\"" + mapname + "\",0);\n";
											linkinit(maketok(o, s2.c_str()), link);
											
											stok *ta;
											if(o->ord < 2)
											{
												s2 = mapname + "=c2_org";
												ta = link.link(c=maketok(plabel, s2.c_str()), plabel->get_prev());
												link.link(maketok(plabel, ";", etype::OP), ta);
											}
											else
											{
												link.link(c=maketok(plabel, mapname.c_str()), plabel->get_prev());
												ta = link.link(maketok(plabel, "=c2_org"), o->prev);
												link.link(maketok(plabel, ";", etype::OP), ta);
											}
										}
										
										parent_label = mapname;
										root_labelindex = uint32_t(root_labels.size());
										clabel &cr = labelmap[mapname] = clabel(c, root_labelindex, psub);
										root_labels.push_back({pstring, &cr});
									}
										
									scope_labels[scopeindex].push_back(pstring);
								}
								else
								{
									error(o, "Label already declared");
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
					case '{':
					{
						VERBOSE(7, "Scope start\n");
						scopelix_stack.push_back(sslix(o));
					}
					break;
					case '}':
					{
						VERBOSE(7, "Scope end\n");
						if(!scopelix_stack.size())
						{
							error(o, "Unexpected '}'");
						}

						scopelix_stack.pop_back();
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
					snprintf(tmp, sizeof(tmp), "var(%s,%d)", o->name, bits);
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
	
	bool isclass = false;
	int64_t isclass_bc = 0;
							
	for(;;)
	{
		stok *o;
		
		stok *sl = nullptr;
		int sline = 0;
		for(;;)
		{
			o = link.pull_tok();
			
			if(!sl)
				sl = o;
			
			if(!o)
				break;
				
			if(o->type != etype::SPACE)
			{
				break;
			}
			else if(*o->name == '\n')
			{
				line++;
				sline++;
			}
		}
		
		if(!o)
			break;
			
		if(sline > 15)
		{
			while(sl != o)
			{
				sl->mute();
				sl = sl->get_next();
			}
			line -= sline;
		}
		
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
						stmp += ".getatlix(c2_lix)";
						link.link(maketok(o, stmp.c_str()), o);
						o->mute();
					}
				}
			}
			break;
			default:
			break;
		};
	}
	
	VERBOSE(5, "Set anonymous references\n");

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
		
		std::string stmp = scope_labels[first->scopeindex][offset];
		stmp += ".getatlix(c2_lix)";
		
		link.link(maketok(first, stmp.c_str()), first);
	}
}

void c2a::c_parse(toklink &link)
{
	VERBOSE(3, "Parsing c2 sections\n");
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
	
	if(!c2_top)
		error(nullptr, "Missing C2_SECTION_TOP");

	if(!c2_asm)
		error(nullptr, "Missing C2_SECTION_ASM");
		
	//Insert a default root label
	stok *after = c2_asm;
	after = link.link(maketok(c2_asm, "\n", etype::SPACE, -1), after);
	after = link.link(maketok(c2_asm, autolabel("root").c_str(), etype::ALPHA, 0), after);
	after = link.link(maketok(c2_asm, ":", etype::OP, 1), after);
	/*after =*/ link.link(maketok(c2_asm, "\n", etype::SPACE, 2), after);
	
	VERBOSE(4, "Parse 0\n");
	s_parse0(link);
	c2_end = link.pull_tok();
	
	VERBOSE(4, "Parse 1\n");
	link.restart(c2_asm, c2_end);
	s_parse1(link);
	
	VERBOSE(4, "Parse 2\n");
	link.restart(c2_asm, c2_end);
	s_parse2(link);
}

void c2a::process(const char *infile, const char *outfile)
{
	VERBOSE(1, "Processing macros\n");
	VERBOSE(3, "Processing macros of %s\n", infile);

	tokline in(*this, files);
	in.load(infile);
	
	toklink link;
	
	stok *o;
	while((o = in.pull_tok()) != nullptr)
		link.push_tok(o);

	link.restart();
	c_parse(link);
	
	tokoutfile write(outfile);
	
	link.restart();
	while((o = link.pull_tok()) != nullptr)
	{
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
		snprintf(errbuf, sizeof(errbuf), "%s:%d: error: %s", files[o->fileindex].c_str(), o->line, tmp);
	}
	else
	{
		snprintf(errbuf, sizeof(errbuf), "error: %s", tmp);
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

void c2a::info(int verboselevel, stok *o, const char *format, ...)
{
	if(verboselevel <= verbose)
	{
		char tmp[256];

		va_list args;
		va_start (args, format);
		vsnprintf (tmp, sizeof(tmp), format, args);
		va_end (args);

		if(o)
		{
			fprintf(stderr, "%s:%d: %s", files[o->fileindex].c_str(), o->line, tmp);
		}
		else
		{
			fprintf(stderr, "%s", tmp);
		}
	}
}
