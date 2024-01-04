GCC := aarch64-linux-gnu-gcc
LD := aarch64-linux-gnu-ld
OBJCOPY := aarch64-linux-gnu-objcopy
QEMU := qemu-system-aarch64

default: build

build: clean
	$(GCC) -c boot.s -o boot.o -Wall -Wextra
	$(GCC) -std=c99 -ffreestanding -mgeneral-regs-only -c main.c -Wall -Wextra
	$(LD) -nostdlib -T linker.ld -o kernel.elf boot.o main.o
	$(OBJCOPY) -O binary kernel.elf kernel.img

qemu: build
	$(QEMU) -M raspi3b -serial stdio -kernel kernel.img

clean:
	rm -f *.o *.elf *.img
