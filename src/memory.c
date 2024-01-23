#include "debug.h"
#include "lib.h"
#include "memory.h"
#include "print.h"
#include "stdbool.h"
#include "stddef.h"

extern char _end;

void load_pgd(uint64_t pgd);

static struct Page free_memory;

static void free_region(uint64_t v_addr, uint64_t end_addr) {
    for (uint64_t i = PA_UP(v_addr); i + PAGE_SIZE <= end_addr; i += PAGE_SIZE) {
        if (i + PAGE_SIZE <= MEMORY_END) {
            kfree(i);
        }
    }
}

void kfree(uint64_t v_addr) {
    ASSERT(v_addr % PAGE_SIZE == 0);
    ASSERT(v_addr >= (uint64_t) &_end);
    ASSERT(v_addr + PAGE_SIZE <= MEMORY_END);

    struct Page* page_addr = (struct Page*) v_addr;
    page_addr->next = free_memory.next; 
    free_memory.next = page_addr; // head of linked list now contains current page
}

void* kalloc() {
    struct Page* page_addr = free_memory.next;

    if (page_addr != NULL) {
        ASSERT((uint64_t) page_addr % PAGE_SIZE == 0);
        ASSERT((uint64_t) page_addr >= (uint64_t) &_end);
        ASSERT((uint64_t) page_addr + PAGE_SIZE <= MEMORY_END);

        free_memory.next = page_addr->next; // move head to next page
    }
    return page_addr;
}

// print memory pages and free memory (sanity check)
void print_pages() {
    struct Page* p = free_memory.next;
    uint64_t size = 0;
    uint64_t i = 0;
    
    while (p != NULL) {
        size += PAGE_SIZE;
        printk("Page %d base address is %x \n", i++, p);
        p = p->next;
    }
    printk("Free Memory: %u MB\n", size/1024/1024);
}

static uint64_t* find_pgd_entry(uint64_t map, uint64_t v_addr, int alloc, uint64_t attr) {
    uint64_t* entry = NULL;
    void* addr = NULL;
    unsigned int entry_idx = (v_addr >> 39) & 0x1FF;

    if (entry[entry_idx] & ENTRY_V) {
        addr = (void*) P2V(PDE_ADDR(entry[entry_idx]));
    } else if (alloc == 1) {
        // create new page
        addr = kalloc();
        if (addr != NULL) {
            memset(addr, 0, PAGE_SIZE);
            entry[entry_idx] = (V2P(addr) | attr | TABLE_ENTRY);
        }
    }
    return addr;
}

static uint64_t* find_pud_entry(uint64_t map, uint64_t v_addr, int alloc, uint64_t attr) {
    uint64_t* entry = NULL;
    void* addr = NULL;
    unsigned int entry_idx = (v_addr >> 30) & 0x1FF;

    entry = find_pgd_entry(map, v_addr, alloc, attr);
    if (entry == NULL) {
        return NULL;
    }

    if (entry[entry_idx] & ENTRY_V) {
        // value in entry points to next level table
        addr = (void*) P2V(PDE_ADDR(entry[entry_idx]));
    } else if (alloc == 1) {
        // create new page
        addr = kalloc();

        if (addr != NULL) {
            memset(addr, 0, PAGE_SIZE);
            entry[entry_idx] = (V2P(addr) | attr | TABLE_ENTRY); // points to lower level table
        }
    }

    return addr;
}

bool map_page(uint64_t map, uint64_t v_addr, uint64_t page_addr, uint64_t attr) {
    uint64_t v_start = PA_DOWN(v_addr);
    uint64_t* entry = NULL;

    ASSERT(v_start + PAGE_SIZE < MEMORY_END);
    ASSERT(page_addr % PAGE_SIZE == 0);
    ASSERT(page_addr + PAGE_SIZE <= V2P(MEMORY_END));

    entry = find_pud_entry(map, v_start, 1, attr);
    if (entry == NULL) {
        return false;
    }

    unsigned int entry_idx = (v_start >> 21) & 0x1FF;
    ASSERT((entry[entry_idx] & ENTRY_V) == 0);
    entry[entry_idx] = (page_addr | attr | BLOCK_ENTRY);

    return true;
}

void free_page(uint64_t map, uint64_t v_start) {
    unsigned int entry_idx;
    uint64_t* entry = NULL;

    ASSERT(v_start % PAGE_SIZE == 0);
    entry = find_pud_entry(map, v_start, 0, 0);

    if (entry != NULL) {
        entry_idx = (v_start >> 21) & 0x1FF;

        if (entry[entry_idx] & ENTRY_V) {
            kfree(P2V(PTE_ADDR(entry[entry_idx])));
            entry[entry_idx] = 0;
        }
    }
}

static void free_pmd(uint64_t map) {
    uint64_t* pgd = (uint64_t*) map;
    uint64_t* pud = NULL;

    for (int i = 0; i < 512; i++) {
        if (pgd[i] & ENTRY_V) {
            pud = (uint64_t*) P2V(PDE_ADDR(pgd[i]));

            for (int j = 0; j < 512; j++) {
                if (pud[j] & ENTRY_V) {
                    kfree(P2V(PDE_ADDR(pud[j])));
                    pud[j] = 0;
                }
            }
        }
    }
}

static void free_pud(uint64_t map) {
    uint64_t* pgd = (uint64_t* ) map;

    for (int i = 0; i < 512; i++) {
        if (pgd[i] & ENTRY_V) {
            kfree(P2V(PDE_ADDR(pgd[i])));
            pgd[i] = 0;
        }
    }
}

static void free_pgd(uint64_t map) {
    kfree(map);
}

void free_vm(uint64_t map) {
    // TODO: temp commented out
    // free_page(map, 0x400000); // free page in user space
    // free_pmd(map);
    // free_pud(map);
    // free_pgd(map);
}

bool setup_uvm() {
    bool status = false;
    // TODO: 
    // unimplented for now
    return status;
}

// switch page translation tables 
void switch_vm(uint64_t map) {
    load_pgd(V2P(map));
}

void init_memory() {
    free_region((uint64_t) &_end, MEMORY_END);
    // print_pages();
}
