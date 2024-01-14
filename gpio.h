#ifndef _GPIO_H
#define _GPIO_H

// Memory mapped I/O base - Peripheral start address (physical address)
#define MMIO_BASE 0x3F000000

// GPIO function select 0
#define GPFSEL0 ((volatile unsigned int*)(MMIO_BASE + 0x00200000))

// GPIO function select 1
#define GPFSEL1 ((volatile unsigned int*)(MMIO_BASE + 0x00200004))

// GPIO function select 2
#define GPFSEL2 ((volatile unsigned int*)(MMIO_BASE + 0x00200008))

// GPIO function select 3
#define GPFSEL3 ((volatile unsigned int*)(MMIO_BASE + 0x0020000C))

// GPIO function select 4
#define GPFSEL4 ((volatile unsigned int*)(MMIO_BASE + 0x00200010))

// GPIO function select 5
#define GPFSEL5 ((volatile unsigned int*)(MMIO_BASE + 0x00200014))

// GPIO pin output set 0
#define GPSET0 ((volatile unsigned int*)(MMIO_BASE + 0x0020001C))

// GPIO pin output set 1
#define GPSET1 ((volatile unsigned int*)(MMIO_BASE + 0x00200020))

// GPIO pin output clear 0
#define GPCLR0 ((volatile unsigned int*)(MMIO_BASE + 0x00200028))

// GPIO pin level 0
#define GPLEV0 ((volatile unsigned int*)(MMIO_BASE + 0x00200034))

// GPIO pin level 1
#define GPLEV1 ((volatile unsigned int*)(MMIO_BASE + 0x00200038))

// GPIO pin event detect status 0
#define GPEDS0 ((volatile unsigned int*)(MMIO_BASE + 0x00200040))

// GPIO pin event detect status 1
#define GPEDS1 ((volatile unsigned int*)(MMIO_BASE + 0x00200044))

// GPIO pin high detect enable 0
#define GPHEN0 ((volatile unsigned int*)(MMIO_BASE + 0x00200064))

// GPIO pin high detect enable 1
#define GPHEN1 ((volatile unsigned int*)(MMIO_BASE + 0x00200068))

// GPIO pin pull-up/down enable
#define GPPUD ((volatile unsigned int*)(MMIO_BASE + 0x00200094))

// GPIO pin pull-up/down enable clock 0
#define GPPUDCLK0 ((volatile unsigned int*)(MMIO_BASE + 0x00200098))

// GPIO pin pull-up/down enable clock 1
#define GPPUDCLK1 ((volatile unsigned int*)(MMIO_BASE + 0x0020009C))

#endif
