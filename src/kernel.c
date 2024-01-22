#include "exception.h"
#include "debug.h"
#include "lib.h"
#include "memory.h"
#include "print.h"
#include "uart.h"

void kmain() {
    init_uart();

    init_memory();
    // init_timer();
    init_interrupt_controller();
    enable_irq();

    printk("Exception level: %u\n", get_el());

    uart_puts("Hello Kernel\n");
    printk("Test printf: %x == %d\n", 0x1337, 0x1337);

    // ASSERT(0);

    // force data abort exception
    // char* p = (char*) 0xFFFF000000000000;
    // *p = 1;
    // printk("An exception should have happened...\n");

    while(1) {
        // echo UART input chars back to UART
        // uart_send(uart_getc());
    }
}
