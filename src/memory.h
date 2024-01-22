#ifndef _MEMORY_H
#define _MEMORY_H

#include "stdint.h"

// kernel base address
#define KERNEL_BASE 0xFFFF000000000000

// convert physical address to virtual address
#define P2V(p) ((uint64_t)(p) + KERNEL_BASE)

// convert virtual address to physical address
#define V2P(v) ((uint64_t)(v) - KERNEL_BASE)

#endif
