#ifndef _DEBUG_H
#define _DEBUG_H

#include "stdint.h"

// hang system if expression fails assertion
#define ASSERT(e) do { if (!(e)) error_check(__FILE__, __LINE__); } while (0)

// print debug information on error
void error_check(char* file, uint64_t line);

#endif
