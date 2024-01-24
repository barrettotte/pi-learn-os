# pi-learn-os

A toy Raspberry Pi 3B kernel for learning.

I wanted to learn the basics of operating system development on something besides x86.

## Implemented

- UART
- Exception level switching
- Basic interrupt handling
- Generic timer
- MMU and paging

## Unimplemented

- Mailboxes
- FAT16 filesystem and disk driver
- processes and process scheduling
- system calls
- ELF and user space programs
- much more...

## Development

```sh
# setup cross compiler
make toolchain

# build
make build

# emulate via Qemu
make run
```

## References

- https://wiki.osdev.org/ARM_Overview
- https://wiki.osdev.org/Raspberry_Pi_Bare_Bones
- https://en.wikipedia.org/wiki/Calling_convention#ARM_(A64)
- [Building an Operating System for the Raspberry Pi](https://jsandler18.github.io/)
- [Arm Cortex-A53 MPCore Processor Technical Reference Manual](https://developer.arm.com/documentation/ddi0500/latest/)
- [ARM Cortex-A Series Programmers Guide for ARMv8-A Instruction Set](https://developer.arm.com/documentation/den0024/a/The-A64-instruction-set)
- [BCM2837 ARM Peripherals](https://cs140e.sergio.bz/docs/BCM2837-ARM-Peripherals.pdf)
