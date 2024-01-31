#pragma once
#include <cstdio>
#define VERBOSE(LEVEL,...) do{if(verbose>=LEVEL){fprintf(stderr,__VA_ARGS__);}}while(0)
//#define ERROR(...) fprintf(stderr,__VA_ARGS__)
