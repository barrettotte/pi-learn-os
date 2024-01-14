#include "uart.h"

void main() {
    uart_init();

    uart_puts("Hello World!\n");
    uart_puts("Test\n");

    while(1) {
        uart_send(uart_getc()); // echo UART input chars back to UART
    }
}
