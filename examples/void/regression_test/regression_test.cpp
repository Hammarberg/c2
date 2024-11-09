#include "c2/h/c2i.h"

class c2_project_regression_test : public c2i
{
public:
	c2_project_regression_test(cmdi *pcmd):c2i(pcmd){}

C2_SECTION_TOP

	void c2_pass() override
	{
		C2_SECTION_ASM
		{
			#include "regression_test.s"
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

	const char *c2_get_template() override
	{
		return "void";
	}
};

c2i *c2_create_object_instance(cmdi *pcmd) {return new c2_project_regression_test(pcmd);}
