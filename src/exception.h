#ifndef _EXCEPTION_H
#define _EXCEPTION_H

#include "stdint.h"

void init_interrupt_controller();
void enable_irq();

void init_timer();
void enable_timer();
uint32_t get_timer_status();
void set_timer_interval(uint32_t value);
uint32_t get_timer_freq();

#endif
