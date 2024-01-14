#ifndef _UART_H
#define _UART_H

// Set baud rate and characteristics (115200 8N1) and map to GPIO
void uart_init();

// Send a single character to UART
void uart_send(unsigned int c);

// Receive a single character from UART
char uart_getc();

// Write string to UART
void uart_puts(char *s);

#endif
