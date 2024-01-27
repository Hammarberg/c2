/*
	c2 - cross assembler
	Copyright (C) 2022-2023  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include <string>
#include <vector>
#include <cstdint>
#if !defined(_WIN32) || defined(__MINGW32__)
#include <strings.h>
#else
#define strcasecmp _stricmp
#define strncasecmp _strnicmp
#endif

namespace json
{
	enum type
	{
		NONE,
		PAIR,
		CONTAINER,
		ARRAY,
		STRING,
		INTEGER,
		BOOLEAN,
		FLOAT
	};

	class base
	{
	public:

		virtual type GetType() const
		{
			return NONE;
		};

		base()
		{
		}

		virtual ~base()
		{
		}

		virtual std::string Encode(bool compact = true, int level = 0, bool com = false)
		{
			return "";
		}
		
		static base *Decode(const char *p)
		{
			base *out = nullptr;
			StaticDecode(&out, p);
			return out;
		}

		virtual bool IsNum() const
		{
			return false;
		}

		virtual const char *GetString(void) const
		{
			return "";
		}

		virtual int64_t GetInteger(void) const
		{
			return 0;
		}

		virtual double GetFloat(void) const
		{
			return 0;
		}

		virtual double GetBool(void) const
		{
			return false;
		}

		base *Find(const char *path, size_t len = 0);

		const base &Get(const char *path);
		
	protected:

		static std::string _level(bool compact, int level)
		{
			std::string s;
			if (!compact)for (int l = 0; l < level; l++)s += "\t";
			return s;
		}

		static const char *_forward(const char *p)
		{
			while (*p && isspace(*p))
				p++;

			return p;
		}

		static const char *_string(std::string &out, const char *p)
		{
			while (*p && *p != '\"')
			{
				out += *p;
				p++;
			}
			p++;

			return p;
		}

		static size_t _slashparse(const char *in)
		{
			size_t n = 0;
			while (in[n] && in[n] != '/')
				n++;
			return n;
		}

		static const char *StaticDecode(base **out, const char *p);

		virtual const char *Decode(base **out, const char *p)
		{
			return p;
		}
	};

	class pair : public base
	{
	public:

		std::string first;
		base *second;

		type GetType() const override
		{
			return PAIR;
		}

		pair(const std::string &in, base *insecond = nullptr)
			: first(in)
			, second(insecond)
		{
		}

		virtual ~pair()
		{
			delete second;
		}

		std::string Encode(bool compact = true, int level = 0, bool com = false) override;

	private:
		const char *Decode(base **out, const char *p) override;

	};

	class container : public base
	{
	public:

		std::vector<base *> data;

		type GetType() const override
		{
			return CONTAINER;
		}

		container()
		{
		}

		virtual ~container()
		{
			for (auto i : data)
			{
				delete i;
			}
		}

		std::string Encode(bool compact = true, int level = 0, bool com = false) override;

	private:
		const char *Decode(base **out, const char *p) override;
	};

	class array : public base
	{
	public:

		std::vector<base *> data;

		type GetType() const override
		{
			return ARRAY;
		}

		array()
		{
		}

		virtual ~array()
		{
			for (auto i : data)
			{
				delete i;
			}
		}

		std::string Encode(bool compact = true, int level = 0, bool com = false) override;
	private:
	
		const char *Decode(base **out, const char *p) override;
	};

	class string : public base
	{
	public:

		std::string data;

		type GetType() const override
		{
			return STRING;
		}

		string(std::string in)
			: data(in)
		{
		}

		virtual ~string()
		{
		}

		std::string Encode(bool compact = true, int level = 0, bool com = false) override;

		const char *GetString(void) const override
		{
			return data.c_str();
		}

		double GetBool(void) const override
		{
			return strcasecmp("true", data.c_str()) == 0;
		}
	};

	class integer : public base
	{
	public:

		int64_t data;

		type GetType() const override
		{
			return INTEGER;
		}

		bool IsNum() const override
		{
			return true;
		}

		integer(int64_t in)
			: data(in)
		{
		}

		virtual ~integer()
		{
		}

		int64_t GetInteger(void) const override
		{
			return data;
		}

		double GetFloat(void) const override
		{
			return double(data);
		}

		double GetBool(void) const override
		{
			return data != 0;
		}

		std::string Encode(bool compact = true, int level = 0, bool com = false) override;
	};

	class boolean : public base
	{
	public:

		bool data;

		type GetType() const override
		{
			return BOOLEAN;
		}

		bool IsNum() const override
		{
			return true;
		}

		boolean(bool in)
			: data(in)
		{
		}

		virtual ~boolean()
		{
		}

		int64_t GetInteger(void) const override
		{
			return data ? 1 : 0;
		}

		double GetFloat(void) const override
		{
			return double(data ? 1 : 0);
		}

		double GetBool(void) const override
		{
			return data;
		}

		std::string Encode(bool compact = true, int level = 0, bool com = false) override;
	};


	class floating : public base
	{
	public:

		double data;

		type GetType() const override
		{
			return FLOAT;
		}

		bool IsNum() const override
		{
			return true;
		}

		floating(double in)
			: data(in)
		{
		}

		virtual ~floating()
		{
		}

		int64_t GetInteger(void) const override
		{
			return int64_t(data);
		}

		double GetFloat(void) const override
		{
			return data;
		}

		double GetBool(void) const override
		{
			return data != 0.0;
		}

		std::string Encode(bool compact = true, int level = 0, bool com = false) override;
	};

};
