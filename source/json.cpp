/*
	c2 - cross assembler
	Copyright (C) 2022-2024  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#include "json.h"
#include <cassert>
#include <cstring>

namespace json
{
	const char *base::StaticDecode(base **out, const char *p)
	{
		base *b = nullptr;

		next:
		p = _forward(p);

		switch (*p)
		{
		case '{':
			b = (base *) new container;
			p = b->Decode(nullptr, p + 1);
			break;
		case '[':
			b = (base *) new array;
			p = b->Decode(nullptr, p + 1);
			break;
		case '\"':
		{
			std::string s;
			p = _string(s, p+1);
			p = _forward(p);
			if (*p == ':')
			{
				b = (base *) new pair(s);
				p = b->Decode(nullptr, p + 1);
			}
			else
			{
				b = (base *) new string(s);
			}
		}
			break;

		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
		case '+':
		case '-':
		case '.':
		{
			std::string s;
			bool fl = false;

			while (*p && (isdigit(*p) || *p == '.' || *p == '+' || *p == '-'|| *p == 'e' || *p == 'E'))
			{
				if (*p == '.')
					fl = true;
				s += *p;
				p++;
			}

			if (fl)
			{
				b = (base *) new floating(atof(s.c_str()));
			}
			else
			{
				b = (base *) new integer(atoll(s.c_str()));
			}
		}
			break;
		case 't':
		case 'T':
		{
			if (strncasecmp(p, "true", 4) == 0)
			{
				b = (base *) new boolean(true);
				p += 4;
			}
			break;
		}
		case 'f':
		case 'F':
		{
			if (strncasecmp(p, "false", 5) == 0)
			{
				b = (base *) new boolean(false);
				p += 5;
			}
			break;
		}
		case ',':
			p++;
			goto next;
		case 0:
			break;
		default:
			assert(false);
			break;
		}

		*out = b;

		return p;
	}

	json::base *base::Find(const char *path, size_t lenght)
	{
		if (*path == '/')
			path++;

		if (!*path)
			return this;

		if (!lenght)
		{
			lenght = _slashparse(path);
		}

		switch (GetType())
		{
		case CONTAINER:
			{
				json::container *c = (json::container *)(this);
				for (auto i : c->data)
				{
					json::base *r = i->Find(path, lenght);
					if (r)
						return r;
				}
			}
			break;
		case ARRAY:
			{
				json::array *c = (json::array *)(this);
				char tmp[16];
				strncpy(tmp, path, lenght);
				size_t index = atoi(tmp);
				if (index >= 0 && index < c->data.size())
				{
					return c->data[index]->Find(path + lenght);
				}
			}
		break;
		case PAIR:
			{
				json::pair *c = (json::pair *)(this);
				if (c->first.size() == lenght && strncmp(path, c->first.c_str(), lenght) == 0)
					return c->second->Find(path + lenght);
			}
			break;
		case STRING:
		case INTEGER:
		case BOOLEAN:
		case FLOAT:
		case NONE:
		default:
			assert(0);
		}

		return nullptr;
	}
	
	const json::base &base::Get(const char *path)
	{
		static json::base def;
		base *p = Find(path);
		if(!p)
			p = &def;
		
		return *p;
	}
	
	std::string json::base::_level(bool compact, int level)
	{
		std::string s;
		if (!compact)for (int l = 0; l < level; l++)s += "\t";
		return s;
	}

	const char *json::base::_forward(const char *p)
	{
		while (*p && isspace(*p))
			p++;

		return p;
	}

	const char *json::base::_string(std::string &out, const char *p)
	{
		while (*p && *p != '\"')
		{
			out += *p;
			p++;
		}
		p++;

		return p;
	}

	size_t json::base::_slashparse(const char *in)
	{
		size_t n = 0;
		while (in[n] && in[n] != '/')
			n++;
		return n;
	}

	const char *container::Decode(base **out, const char *p)
	{
		while ((p = _forward(p)) && *p!='}')
		{
			base *out = nullptr;
			p = StaticDecode(&out, p);
			data.push_back(out);
		}

		return p+1;
	}

	const char *pair::Decode(base **out, const char *p)
	{
		p = StaticDecode(&second, p);
		return p;
	}

	const char *array::Decode(base **out, const char *p)
	{
		while ((p = _forward(p)) && *p != ']')
		{
			base *out = nullptr;
			p = StaticDecode(&out, p);
			data.push_back(out);
		}

		return p+1;
	}

	std::string pair::Encode(bool compact, int level, bool com)
	{
		return _level(compact, level) + "\"" + first + (compact ? "\":" : "\": ")  +  second->Encode(compact, level, com) + "\n";
	}

	std::string container::Encode(bool compact, int level, bool com)
	{
		std::string s = (compact ? "{" : "{\n");

		for (size_t r = 0; r < data.size(); r++)
		{
			auto i = data[r];
			s += i->Encode(compact, level + 1, r + 1 < data.size());
		}

		s += _level(compact, level);
		s += com ? "}," : "}";

		return s;
	}

	std::string array::Encode(bool compact, int level, bool com)
	{
		std::string s = (compact ? "[" : "[\n");

		for (size_t r = 0; r < data.size(); r++)
		{
			auto i = data[r];
			s += i->Encode(compact, level + 1, r + 1 < data.size());
		}

		s += _level(compact, level);
		s += com ? "]," : "]";

		return s;
	}

	std::string string::Encode(bool compact, int level, bool com)
	{
		return "\"" + data + (com ? "\"," : "\"");
	}

	std::string integer::Encode(bool compact, int level, bool com)
	{
		char buf[64];
#if !(defined(_WIN32) || defined(_WIN64) || defined(__APPLE__))
		snprintf(buf, sizeof(buf), "%ld", data);
#else
		snprintf(buf, sizeof(buf), "%lld", data);
#endif
		return std::string(buf) + (com ? "," : "");
	}

	std::string boolean::Encode(bool compact, int level, bool com)
	{
		return std::string(data?"true":"false") + (com ? "," : "");
	}

	std::string floating::Encode(bool compact, int level, bool com)
	{
		char buf[64];
		snprintf(buf, sizeof(buf), "%g", data);
		return std::string(buf) + (com ? "," : "");
	}
};
