#include "exception.h"
#include "irq.h"
#include "lib.h"
#include "print.h"
#include "stdint.h"
#include "uart.h"

static uint32_t timer_interval = 0;
static uint64_t ticks = 0;

void init_interrupt_controller() {
    set_word(DISABLE_BASIC_IRQS, 0xFFFFFFFF);
    set_word(DISABLE_IRQS_1, 0xFFFFFFFF);
    set_word(DISABLE_IRQS_2, 0xFFFFFFFF);

    set_word(ENABLE_IRQS_2, (1 << 25));
}

static uint32_t get_irq_number() {
    return get_word(IRQ_BASIC_PENDING);
}

void init_timer() {
    timer_interval = get_timer_freq() / 100;
    enable_timer();
    set_word(CNTP_EL0, (1 << 1));
}

static void timer_irq_handler() {
    uint32_t status = get_timer_status();

    if (status & (1 << 2)) {
        ticks++;
    
        if (ticks % 100 == 0) {
            printk("Timer interrupt! %d ticks\n", ticks);
        }
        set_timer_interval(timer_interval);
    }
}

static void irq_handler() {
    uint32_t irq;
    irq = get_word(CNTP_STATUS_EL0);
    
    if (irq & (1 << 1)) {
        timer_irq_handler();
    } else {
        irq = get_irq_number();
        if (irq & (1 << 19)) {
            uart_handler();
        } else {
            printk("Unknown IRQ %x\n", irq);
            while (1) {}
        }
    }
}

void exception_handler(uint64_t vector, uint64_t esr, uint64_t elr) {
    switch (vector) {
        case 1:
            printk("Sync error. elr=%x, esr=%x\n", elr, esr);
            while (1) {}
            break;
        case 2:
            irq_handler();
            break;
        default:
            printk("Unknown error. elr=%x, esr=%x\n", elr, esr);
            while (1) {}
            break;
    }
}
