/*
	c2 - cross assembler
	Copyright (C) 2022-2023  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include <memory>
#include <map>
#include "tokfeed.h"
#include "macro.h"
#include "linear.h"

class c2a : public slinear_alloc<>
{
public:

	c2a(bool inverbose)
	: verbose(inverbose)
	{
		// Create root scope space
		scope_labels.push_back(std::vector<const char *>());
	}
	~c2a();

	// Map of discovered macro definitions
	std::unordered_map<std::string, std::multimap<int, std::shared_ptr<cmacro>>> macros;

	// Information about each label
	struct clabel
	{
		clabel(stok *o=nullptr, int32_t ri=0, stok *insub = nullptr)
		: pos(o)
		, sub(insub)
		, root_labelindex(ri)
		{}
		
		stok *pos;	// ptr to label name
		stok *sub;	// ptr to top where sub labels are inserted
		int32_t root_labelindex;	// Index to root_labels
	};

	// Index array of files
	std::vector<std::string> files;

	// Map of labels
	std::unordered_map<std::string, clabel> labelmap;
	
	// Current active root label index
	uint32_t root_labelindex = 0;
	
	// Index of root labels
	std::vector<std::pair<const char *, clabel *>> root_labels;

	// Label index scopes for c2_lix, unique code point number
	uint32_t scopelix = 0;
	
	// Scopes, used for no name label referencing
	uint32_t scopeindex = 0;
	std::vector<uint32_t> scope_stack;
	std::vector<std::vector<const char *>> scope_labels;
	
	// ptr to un-named label references from macro arguments: -, +, --, ++, etc
	std::vector<std::pair<stok *, stok *>> anonymous;

	// Root label name
	std::string parent_label;
	
	static std::string escape_var(const char *pstr);
	static std::string unescape_var(const char *pstr);
	
	stok *get_next_nonspace(toklink &link, bool unlink = false);
	
	//stok *traverse_argument(stok *o, toklink &link);
	
	static bool match_macro_parameters_pos_forward(int pos, const std::vector<stok *> &def, const std::vector<stok *> &par, int **idx, const int NUM_DEF, const int NUM_PAR);
	bool match_macro_parameters(const std::vector<stok *> &def, const std::vector<stok *> &par, const std::vector<std::pair<std::string, std::vector<const char *>>> &inputs, std::vector<std::vector<stok *>> &outargs, std::vector<bool> &outisarray);
	bool match_macro(stok *o, toklink &link);
	
	void parse_macro_body(toklink &in, toklink &out);
	void parse_macro(toklink &link);
	void s_parse0(toklink &link);
	void s_parse1(toklink &link);
	void s_parse2(toklink &link);
	void c_parse(toklink &link);
	void process(const char *infile, const char *outfile);
	
	stok *c2_top = nullptr;
	stok *c2_asm = nullptr;
	stok *c2_end = nullptr;
	
	bool verbose = false;
	
	stok *preprocessprefix(stok *o, toklink &link);

	stok *linkinit(stok *p, toklink &out);
private:

	const char *linear_string(const std::string &s)
	{
		char *p = (char *)alloc(s.size() + 1);
		strcpy(p, s.c_str());
		return p;
	}
	
	const char *linear_cstring(const char *s)
	{
		size_t len = strlen(s) + 1;
		char *p = (char *)alloc(len);
		memcpy(p, s, len);
		return p;
	}
	
	static uint16_t explicit_bitcount(const char *s);

	stok *maketok(const stok *t, const char *name, etype type = etype::BLOCK, int16_t inord = -1);
	
	stok *clone(const stok *o);
	
	static int64_t bracketcount(int64_t bc, const stok *o);
	static int64_t rbracketcount(int64_t bc, const stok *o);
	
	uint32_t auto_num = 0;
	std::string autolabel(const char *hint = nullptr, bool local = false);
	
	void error(stok *o, const char *format, ...);
	void warning(stok *o, const char *format, ...);
	
};