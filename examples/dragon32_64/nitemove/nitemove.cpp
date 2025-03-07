#include "c2/dragon/dragon.h"

class c2_project_nitemove : public dragon
{
public:
	c2_project_nitemove(cmdi *pcmd):dragon(pcmd){}

C2_SECTION_TOP

	void c2_pass() override
	{
		C2_SECTION_ASM
		{
			#include "nitemove.s"
		}
	}

	void c2_pre() override
	{
		dragon::c2_pre();
		// Insert custom pre-pass code here
	}

	void c2_post() override
	{
		dragon::c2_post();
		// Insert custom post-pass code here
	}

	const char *c2_get_template() override
	{
		return "dragon";
	}
};

c2i *c2_create_object_instance(cmdi *pcmd) {return new c2_project_nitemove(pcmd);}
