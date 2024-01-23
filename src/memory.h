#ifndef _MEMORY_H
#define _MEMORY_H

#include "stdbool.h"
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

// retrieve address of next level entry (global and upper directory table entries)
#define PDE_ADDR(p) ((uint64_t) p & 0xfffffffffffff000)

// retrieve address of physical page
#define PTE_ADDR(p) ((uint64_t) p & 0xffffffffffe00000)

//
#define ENTRY_V (1 << 0)

//
#define TABLE_ENTRY (1 << 1)

//
#define BLOCK_ENTRY (0 << 1)

//
#define ENTRY_ACCESSED (1 << 10)

//
#define NORMAL_MEMORY (1 << 2)

//
#define DEVICE_MEMORY (0 << 2)

//
void init_memory();

// kernel allocate memory
void* kmalloc();

// kernel free memory
void kfree(uint64_t v_addr);

//
bool map_page(uint64_t map, uint64_t v_addr, uint64_t p_page, uint64_t attr);

// setup kernel space virtual memory
void switch_vm(uint64_t map);

// setup user space virtual memory
bool setup_uvm();

// used to maintain linked list of pages
struct Page {
    struct Page* next;  
};

#endif
