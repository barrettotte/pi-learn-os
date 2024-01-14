#ifndef _UART_H
#define _UART_H

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

// Set baud rate and characteristics (115200 8N1) and map to GPIO
void uart_init();

// Send a single character to UART
void uart_send(unsigned int c);

// Receive a single character from UART
char uart_getc();

// Write string to UART
void uart_puts(char *s);

#endif
