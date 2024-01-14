#include "debug.h"
#include "lib.h"
#include "print.h"
#include "uart.h"

void main() {
    uart_init();

    uart_puts("Hello Kernel\n");
    printk("Test print: %x == %d\n", 0x1337, 0x1337);

    printk("Exception level: %u\n", get_el());

    // ASSERT(0);

    while(1) {
        uart_send(uart_getc()); // echo UART input chars back to UART
    }
}
