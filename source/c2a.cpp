/*
	c2 - cross assembler
	Copyright (C) 2022-2024  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#include "c2a.h"
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

std::string &c2a::makelower(std::string &s)
{
	std::transform(s.begin(), s.end(), s.begin(),[](unsigned char c){ return std::tolower(c);});
	return s;
}

const char *c2a::linear_string(const std::string &s)
{
	char *p = (char *)alloc(s.size() + 1);
	strcpy(p, s.c_str());
	return p;
}

const char *c2a::linear_cstring(const char *s)
{
	size_t len = strlen(s) + 1;
	char *p = (char *)alloc(len);
	memcpy(p, s, len);
	return p;
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

c2a::c2a(int inverbose)
: verbose(inverbose)
{
	// Create root scope space
	scope_labels.push_back(std::vector<const char *>());
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

void c2a::s_parse0(toklink &link)
{
	int bracket_count = 0;
	std::string stmp;
	
	for(;;)
	{
		stok *o = get_next_nonspace(link);
		if(!o)
			error(o, "Unexpected end of file");
			
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

void c2a::s_parse1_insert_slix(stok *o, bool macro, toklink &link)
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
		info(6, nullptr, "slix %p\n",slix.start);

		// Push debug stack and scope label index
		slix.implemented = true;
		slix.slix = scopelix;

		char ctmp[256];
		if(!macro)
		{
			snprintf(ctmp, sizeof(ctmp), "c2_scope(%d,%d,%d);", int(slix.start->fileindex), slix.start->line, int(scopelix));
		}
		else
		{
			snprintf(ctmp, sizeof(ctmp), "c2_scope(c2if,c2il,%d);", int(scopelix));
		}

		link.link(maketok(slix.start, ctmp), link.link(maketok(slix.start, "c2_sscope "), slix.start));
		scopelix++;
	}
}

void c2a::s_parse1(toklink &link)
{
	std::string stmp;
	bool label_declared = false;
	bool switchhead = false;		// True while traversing the argument part of a switch statements
	int64_t switchcount = 0;		// Positive while traversing a switch block
	int64_t prev_switchcount;

	for(;;)
	{
		stok *o = get_next_nonspace(link);
		
		if(!o)
			return;
			
		stok *op[3] = {o->get_prev_nonspace(), o, o->get_next_nonspace()};
		
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

		prev_switchcount = switchcount;

		if(switchhead || switchcount)
		{
			switchcount = bracketcount(switchcount, o);

			if(!switchcount)
				if(switchhead)
					info(7, o, "End of switch head\n");
				else
					info(7, o, "End of switch block\n");
		}
			
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
				else if(!strcasecmp("global", o->name))
				{
					if(o->ord != 0 && !label_declared)
					{
						error(o, "Unexpected global location");
					}

					//Slap on ;
					stok *n = o;
					while(o->is_same_line(n))
					{
						n = n->get_next();
						if(!n)
							error(o, "Unexpected end of file");
					}

					link.link(maketok(o, ";", etype::OP), n->get_prev_nonspace());

					linkinit(maketok(o, "var "), link);
					linkinit(clone(op[2]), link);
					linkinit(maketok(o, ";\n"), link);

					o->mute();
				}
				else if(!strcasecmp("import", o->name))
				{
					if(o->ord != 0 && !label_declared)
					{
						error(o, "Unexpected import location");
					}

					linkinit(maketok(o, "c2_label "), link);
					linkinit(clone(op[2]), link);
					linkinit(maketok(o, "=c2_slabel(\""), link);
					linkinit(clone(op[2]), link);
					linkinit(maketok(o, "\", 0, 1);"), link);

					stok *n = o;
					while(o->is_same_line(n))
					{
						n->mute();
						n = n->get_next();
						if(!n)
							error(o, "Unexpected end of file");
					}
				}
				else if(!strcasecmp("switch", o->name))
				{
					int64_t bc = 0;
					bool gothead = false;
					stok *n = o->get_next();

					while(n)
					{
						bc = bracketcount(bc, n);

						if(!gothead)
							gothead = bc != 0;

						if(!bc)
							break;

						n = n->get_next();
					}

					if(gothead && n && (n = n->get_next_nonspace()) && *n->name == '{')
					{
						info(7, o, "C switch detected\n");
						switchhead = true;
					}
				}
				else if((o->ord == 0 || label_declared) && match_macro(o, link))
				{
					// Make sure the right scope is set up
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
						if(*o->get_next()->name != ':' && switchcount == 0)	//Avoid C++ namespaces and c switch blocks
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
								s_parse1_insert_slix(plabel, false, link);

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
								
								info(6, plabel, "Label %s\n", mapname.c_str());
								
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

									char cstrlix[64];
									snprintf(cstrlix, sizeof(cstrlix), "%d", int(scopelix_stack[scopelix_stack.size()-1].slix));
									
									if(local)
									{
										// Local label setup
										clabel &cr = *root_labels[root_labelindex - (numdots - 1)].second;

										if(!cr.sub)
										{
											cr.sub = init_subspace(link, root_mapname, true);
										}
										
										s2 = "c2i::c2_label " + stmp + "=c2_slabel(\"" + mapname + "\"," + std::string(cstrlix) + ");\n";
										cr.sub = link.link(maketok(cr.sub, s2.c_str()), cr.sub);
										
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

											s2 = "c2_baselabel<" + subname + "> " + stmp + "=c2_slabel(\"" + mapname + "\"," + std::string(cstrlix) + ");\n";
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
						if(switchhead && switchcount && !prev_switchcount)
						{
							info(7, o, "Start of switch block\n");
							switchhead = false;
						}

						if(!switchcount && !switchhead)
						{
							info(7, o, "Scope start\n");
							scopelix_stack.push_back(sslix(o));
							if(parse1_macro_expanded)
							{
								info(7, o, "Inserting macro c2_scope\n");
								s_parse1_insert_slix(o, true, link);
								parse1_macro_expanded = false;
							}
						}
					}
					break;
					case '}':
					{
						if(!prev_switchcount && !switchhead)
						{
							info(7, o, "Scope end\n");
							if(!scopelix_stack.size())
							{
								error(o, "Unexpected '}'");
							}

							scopelix_stack.pop_back();
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
			default:
			break;
		};
	}
	
	info(5, nullptr, "Set anonymous references\n");

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
		
		link.link(maketok(first, stmp.c_str()), first);
	}
}

void c2a::c_parse(toklink &link)
{
	info(3, nullptr, "Parsing c2 sections\n");
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

	stok *after = c2_imp = c2_asm;

	//Insert a default root label
	after = link.link(maketok(c2_asm, "\n", etype::SPACE, -1), after);
	after = link.link(maketok(c2_asm, autolabel("root").c_str(), etype::ALPHA, 0), after);
	after = link.link(maketok(c2_asm, ":", etype::OP, 1), after);
	/*after =*/ link.link(maketok(c2_asm, "\n", etype::SPACE, 2), after);
	
	info(4, nullptr, "Parse 0\n");
	s_parse0(link);
	c2_end = link.pull_tok();
	
	info(4, nullptr, "Parse 1\n");
	link.restart(c2_asm, c2_end);
	s_parse1(link);
	
	info(4, nullptr, "Parse 2\n");
	link.restart(c2_asm, c2_end);
	s_parse2(link);
}

void c2a::process(const char *infile, const char *outfile)
{
	info(1, nullptr, "Processing macros\n");
	info(3, nullptr, "Processing macros of %s\n", infile);

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
