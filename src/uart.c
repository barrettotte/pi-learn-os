#include "lib.h"
#include "uart.h"

void uart_send(unsigned int c) {
    while (get_word(UART0_FR) & (1 << 3)) {}
    set_word(UART0_DR, c);
}

unsigned int uart_recv() {
    return get_word(UART0_DR);
}

void uart_puts(const char* s) {
    for (int i = 0; s[i] != '\0'; i++) {
        uart_send(s[i]);
    }
}

void uart_handler() {
    uint32_t status = get_word(UART0_MIS);

    if (status & (1 << 4)) {
        char c = uart_recv();

        if (c == '\r') {
            uart_puts("\r\n");
        }
        else {
            uart_send(c);
        }

        set_word(UART0_ICR, (1 << 4));
    }
}

void uart_init() {
    set_word(UART0_CR, 0);
    set_word(UART0_IBRD, 26);
    set_word(UART0_FBRD, 0);
    set_word(UART0_LCRH, (1 << 5) | (1 << 6));
    set_word(UART0_IMSC, (1 << 4));
    set_word(UART0_CR, (1 << 0) | (1 << 8) | (1 << 9));
}
