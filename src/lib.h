#ifndef _LIB_H
#define _LIB_H

#include "stdint.h"

// delay system for cycles
void delay(uint64_t cycles);

// TODO: move to memory.h
// set word at address
void set_word(uint64_t addr, uint32_t word);

// TODO: move to memory.h
// fetch word at address
uint32_t get_word(uint64_t addr);

// TODO: move to memory.h
// set block of memory to value
void memset(void* dst, int value, unsigned int size);

// TODO: move to memory.h
// copy block of memory from destination to source
void memcpy(void* dst, void* src, unsigned int size);

// TODO: move to memory.h
// move block of memory from destination to source
void memmove(void* dst, void* src, unsigned int size);

// TODO: move to memory.h
// compare two blocks of memory
void memcmp(void* a, void* b, unsigned int size);

// get current exception level
unsigned char get_el();

#endif
