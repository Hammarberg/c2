#include "{super}.h"

class c2_project_{title} : public {super}
{
public:
	c2_project_{title}(cmdi *pcmd):{super}(pcmd){}

C2_SECTION_TOP

	void c2_pass() override
	{
		C2_SECTION_ASM
		{
			#include "{title}.s"
		}
	}

	void c2_pre() override
	{
		{super}::c2_pre();
		// Insert custom pre-pass code here
	}

	void c2_post() override
	{
		{super}::c2_post();
		// Insert custom post-pass code here
	}
};

c2i *c2_create_object_instance(cmdi *pcmd) {return new c2_project_{title}(pcmd);}
