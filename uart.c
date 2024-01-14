#include "gpio.h"

// Auxilary enables. Used to enable the three modules; UART, SPI1, SPI2
#define AUX_ENABLES ((volatile unsigned int*)(MMIO_BASE + 0x00215004))

// Mini UART I/O data
#define AUX_MU_IO_REG ((volatile unsigned int*)(MMIO_BASE + 0x00215040))

// Mini UART interrupt enable
#define AUX_MU_IER_REG ((volatile unsigned int*)(MMIO_BASE + 0x00215044))

// Mini UART interrupt identify
#define AUX_MU_IIR_REG ((volatile unsigned int*)(MMIO_BASE + 0x00215048))

// Mini UART line control
#define AUX_MU_LCR_REG ((volatile unsigned int*)(MMIO_BASE + 0x0021504C))

// Mini UART modem control
#define AUX_MU_MCR_REG ((volatile unsigned int*)(MMIO_BASE + 0x00215050))

// Mini UART line status
#define AUX_MU_LSR_REG ((volatile unsigned int*)(MMIO_BASE + 0x00215054))

// Mini UART modem status
#define AUX_MU_MSR_REG ((volatile unsigned int*)(MMIO_BASE + 0x00215058))

// Mini UART scratch
#define AUX_MU_SCRATCH ((volatile unsigned int*)(MMIO_BASE + 0x0021505C))

// Mini UART extra control
#define AUX_MU_CNTL_REG ((volatile unsigned int*)(MMIO_BASE + 0x00215060))

// Mini UART extra status
#define AUX_MU_STAT_REG ((volatile unsigned int*)(MMIO_BASE + 0x00215064))

// Mini UART baudrate
#define AUX_MU_BAUD_REG ((volatile unsigned int*)(MMIO_BASE + 0x00215068))

void uart_init() {
    // initialize UART
    *AUX_ENABLES |= 1; // enable UART1, AUX mini uart
    *AUX_MU_CNTL_REG = 0;
    *AUX_MU_LCR_REG = 3; // 8 bits
    *AUX_MU_MCR_REG = 0;
    *AUX_MU_IER_REG = 0;
    *AUX_MU_IIR_REG = 0xC6; // disable interrupts
    *AUX_MU_BAUD_REG = 270; // 115200 baud

    // map UART1 to GPIO pins
    register unsigned int r = *GPFSEL1;
    r &= ~((7 << 12) | (7 << 15)); // gpio14, gpio15
    r |= (2 << 12) | (2 << 15); // alt5
    *GPFSEL1 = r;
    *GPPUD = 0; // enable pins 14 and 15

    r = 150;
    while (r--) {
        asm volatile("nop");
    }
    *GPPUDCLK0 = (1 << 14) | (1 << 15);

    r = 150;
    while (r--) {
        asm volatile("nop");
    }
    *GPPUDCLK0 = 0; // flush GPIO setup
    *AUX_MU_CNTL_REG = 3; // enable Tx, Rx
}

void uart_send(unsigned int c) {
    // wait until able to send
    do {
        asm volatile("nop");
    } while (!(*AUX_MU_LSR_REG & 0x20));

    *AUX_MU_IO_REG = c; // write char to buffer
}

char uart_getc() {
    // wait until something in buffer
    do {
        asm volatile("nop");
    } while (!(*AUX_MU_LSR_REG & 0x01));

    char r = (char)(*AUX_MU_IO_REG);
    return r == '\r' ? '\n' : r; // convert carriage return to newline
}

void uart_puts(char *s) {
    while(*s) {
        uart_send(*s++);
    }
}
