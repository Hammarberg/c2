#include "c2/c64/c64.h"
#include <cmath>

class c2_project_polarplasma : public c64
{
public:
	c2_project_polarplasma(cmdi *pcmd):c64(pcmd){}

C2_SECTION_TOP

	void c2_pass() override
	{
		C2_SECTION_ASM
		{
			#include "polarplasma.s"
		}
	}

	void c2_pre() override
	{
		c64::c2_pre();
		// Insert custom pre-pass code here
	}

	void c2_post() override
	{
		c64::c2_post();
		// Insert custom post-pass code here
	}

	const char *c2_get_template() override
	{
		return "c64vice";
	}
};

c2i *c2_create_object_instance(cmdi *pcmd) {return new c2_project_polarplasma(pcmd);}
