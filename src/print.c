#include "stdint.h"
#include "stdarg.h"
#include "uart.h"

static int uint_to_hex(char* buffer, int pos, uint64_t uint) {
    char digits[16] = "0123456789ABCDEF";
    char digits_buffer[25];
    int size = 0;

    do {
        digits_buffer[size++] = digits[uint % 16];
        uint /= 16;
    } while (uint != 0);

    // prefix
    buffer[pos++] = '0';
    buffer[pos++] = 'x';

    // reverse the buffer
    for (int i = size-1; i >= 0; i--) {
        buffer[pos++] = digits_buffer[i];
    }

    return size + 2; // +2 for '0x'
}

static int uint_to_decimal(char* buffer, int pos, uint64_t uint) {
    char digits[10] = "0123456790";
    char digits_buffer[25];
    int size = 0;

    do {
        digits_buffer[size++] = digits[uint % 10];
        uint /= 10;
    } while (uint != 0);

    // reverse the buffer
    for (int i = size-1; i >= 0; i--) {
        buffer[pos++] = digits_buffer[i];
    }

    return size;
}

static int int_to_decimal(char* buffer, int pos, int64_t integer) {
    int size = 0;

    // handle negative numbers
    if (integer < 0) {
        integer = -integer;
        buffer[pos++] = '-';
        size = 1;
    }

    size += uint_to_decimal(buffer, pos, (uint64_t) integer);
    return size;
}

static int read_string(char* buffer, int pos, const char* s) {
    int i = 0;
    for (i = 0; s[i] != '\0'; i++) {
        buffer[pos++] = s[i];
    }
    return i;
}

static void write_console(const char* buffer, int size) {
    for (int i = 0; i < size; i++) {
        uart_send(buffer[i]);
    }
}

int printk(const char* fmt, ...) {
    char buffer[1024];
    int buffer_size = 0;

    int64_t arg_i = 0;
    char* arg_s = 0;

    va_list args;
    va_start(args, fmt);

    for (int i = 0; fmt[i] != '\0'; i++) {
        if (fmt[i] != '%') {
            buffer[buffer_size++] = fmt[i];
        } else {
            switch (fmt[++i]) {
                case 'x':
                    arg_i = va_arg(args, int64_t);
                    buffer_size += uint_to_hex(buffer, buffer_size, (uint64_t) arg_i);
                    break;
                case 'u':
                    arg_i = va_arg(args, int64_t);
                    buffer_size += uint_to_decimal(buffer, buffer_size, (uint64_t) arg_i);
                    break;
                case 'd':
                    arg_i = va_arg(args, int64_t);
                    buffer_size += int_to_decimal(buffer, buffer_size, arg_i);
                    break;
                case 's':
                    arg_s = va_arg(args, char*);
                    buffer_size += read_string(buffer, buffer_size, arg_s);
                    break;
                default:
                    buffer[buffer_size++] = '%';
                    i--;
                    break;
            }
        }
    }

    write_console(buffer, buffer_size);
    va_end(args);
    return buffer_size;
}
