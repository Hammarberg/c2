#include "c2/h/c2i.h"
#include <cmath>

class c2_project_bmp : public c2i
{
public:
	c2_project_bmp(cmdi *pcmd):c2i(pcmd){}

C2_SECTION_TOP

	void c2_pass() override
	{
		C2_SECTION_ASM
		{
			#include "bmp.s"
		}
	}

	void c2_pre() override
	{
		c2i::c2_pre();
		// Insert custom pre-pass code here
	}

	void c2_post() override
	{
		c2i::c2_post();
		// Insert custom post-pass code here
	}
};

c2i *c2_create_object_instance(cmdi *pcmd) {return new c2_project_bmp(pcmd);}
