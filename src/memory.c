#include "debug.h"
#include "memory.h"
#include "print.h"
#include "stddef.h"

extern char _end;

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

void check_memory() {
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

void init_memory() {
    free_region((uint64_t) &_end, MEMORY_END);
    check_memory(); // sanity check
}
