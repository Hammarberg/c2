/*
	c2 - cross assembler
	Copyright (C) 2022-2024  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#include "c2a.h"

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
	bool recursion = false;

	for(auto mi = v.rbegin(); mi != v.rend(); mi++)
	{
		cmacro *m = mi->second.get();
		//m->print();

		if(m->disablecount)
		{
			recursion = true;
			continue;
		}

		std::vector<stok *> def;  // Macro header definition
		m->signature.restart();
		stok *t = m->signature.pull_tok();
		while(t)
		{
			def.push_back(t);
			t = t->get_next();
		}

		if(match_macro_parameters(def, par, m->inputs, outargs, outisarray))
		{
			assert(outargs.size() == m->inputs.size());


			if(m->implementation.empty())
			{
				toklink out = link;
				out.restart(c2_imp);

				m->implementation = autolabel(io->name);

				// Generate macro lambda
				out.push_tok(maketok(io, "auto "));
				out.push_tok(maketok(io, m->implementation.c_str()));
				out.push_tok(maketok(io, "=[&](int c2if,int c2il"));
				for(size_t r=0;r<m->inputs.size();r++)
				{
					out.push_tok(maketok(io, ",", etype::OP));
					out.push_tok(maketok(io, "var "));
					out.push_tok(maketok(io, m->inputs[r].first.c_str(), etype::ALPHA));
				}
				out.push_tok(maketok(io, ")"));

				// Prepare macro link for streaming
				m->restart();

				// The first op from the macro should be '{', push it
				o = m->pull_tok();
				assert(o && *o->name == '{');
				stok *rpos;
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
				out.push_tok(maketok(out.get_pos(), ";", etype::OP));

				// Restore namespace
				out.push_tok(maketok(io, "c2_namespace", etype::ALPHA));
				out.push_tok(maketok(io, " ", etype::SPACE));
				out.push_tok(maketok(io, parent_label.c_str(), etype::ALPHA));

				// Pop current scope
				out.push_tok(maketok(io, " ", etype::SPACE));
				out.push_tok(maketok(io, "c2_scope_internal_pop", etype::ALPHA));

				// Recursively run parse1 over the expanded macro body
				parse1_macro_expanded = true;
				toklink sub = link;
				sub.restart(rpos, out.get_pos());
				s_parse1(sub);

				c2_imp = out.get_pos();
			}

			toklink out = link;
			out.restart(io->get_prev());

			// Call lambda
			out.push_tok(maketok(io, m->implementation.c_str()));

			// Set restart pos if not already set
			stok *rpos = out.get_pos();

			char ctmp[128];
			snprintf(ctmp, sizeof(ctmp), "(%d,%d", int(io->fileindex), io->line);
			out.push_tok(maketok(io, ctmp, etype::OP));

			// Expand arguments into vars or arrays
			if(outargs.size())
			{
				for(size_t t=0; t<outargs.size(); t++)
				{
					out.push_tok(maketok(io, ",", etype::OP));

					std::vector<stok *> &args = outargs[t];

					bool isarray = outisarray[t];

					if(isarray)
						out.push_tok(maketok(io, "{", etype::OP));

					stok *anon_first = nullptr;
					stok *anon_last = nullptr;
					bool anon_valid = args.size() != 0;

					for(size_t r=0;r<args.size();r++)
					{
						stok *c = clone(args[r]);
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

					if(anon_valid)
					{
						anonymous.push_back({anon_first, anon_last});
					}

					if(isarray)
						out.push_tok(maketok(io, "}", etype::OP, 10));
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

	if(recursion)
		error(io, "Recursive macro reference");

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
			error(o->get_prev(), "Unexpected end of macro");

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

	info(5, title, "Parsing macro %s\n", names[0].c_str());

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

		int priority = int(signature.count()+signature_offset);

		if(i == macros.end())
		{
			macros[name].insert({priority, m});
		}
		else
		{
			auto &v = i->second;

			for(auto mi = v.rbegin(); mi != v.rend(); mi++)
			{
				if(mi->second->cmp(*m.get()))
				{
					info(6, title, "Overriding macro %s\n", name.c_str());
					priority = mi->first + 1;
					break;
				}
			}

			info(6, title, "Overloading macro %s\n", name.c_str());
			i->second.insert({signature.count()+signature_offset, m});
		}
	}

	link.unlink(o);
	m->push_tok(o);	//Push {
	//m->push_tok(makeprefix(o));
	parse_macro_body(link, *m);
}
