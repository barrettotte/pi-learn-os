#ifndef _MEMORY_H
#define _MEMORY_H

#include "stdint.h"

// kernel base address
#define KERNEL_BASE 0xFFFF000000000000

// convert physical address to virtual address
#define P2V(p) ((uint64_t)(p) + KERNEL_BASE)

// convert virtual address to physical address
#define V2P(v) ((uint64_t)(v) - KERNEL_BASE)

// end of free memory (before file system)
#define MEMORY_END P2V(0x30000000)

// 2MB page size
#define PAGE_SIZE (2 * 1024 * 1024)

// align page address to next 2MB boundary, if not aligned
#define PA_UP(v) ((((uint64_t) v + PAGE_SIZE - 1) >> 21) << 21)

// align page address to previous 2MB boundary, if not aligned
#define PA_DOWN(v) (((uint64_t) v >> 21) << 21)

void init_memory();

// kernel allocate memory
void* kmalloc();

// kernel free memory
void kfree(uint64_t v_addr);

// used to maintain linked list of pages
struct Page {
    struct Page* next;  
};

#endif
