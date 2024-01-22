#ifndef _UART_H
#define _UART_H

#include "memory.h"

#define IO_BASE P2V(0x3f200000)

#define UART0_DR   (IO_BASE + 0x1000)
#define UART0_FR   (IO_BASE + 0x1018)
#define UART0_CR   (IO_BASE + 0x1030)
#define UART0_LCRH (IO_BASE + 0x102c)
#define UART0_FBRD (IO_BASE + 0x1028)
#define UART0_IBRD (IO_BASE + 0x1024)
#define UART0_IMSC (IO_BASE + 0x1038)
#define UART0_MIS  (IO_BASE + 0x1040)
#define UART0_ICR  (IO_BASE + 0x1044)

// init UART baud rate and characteristics
void init_uart();

// receive a single character from UART
unsigned int uart_recv();

// send a single character to UART
void uart_send(unsigned int c);

// write string to UART
void uart_puts(const char* s);

// handle UART interrupt
void uart_handler();

#endif
