AARCH64 := aarch64-none-elf
CROSS := /opt/cross/gcc-arm-10.3-2021.07-x86_64-$(AARCH64)/bin

AS := $(CROSS)/$(AARCH64)-as
GCC := $(CROSS)/$(AARCH64)-gcc
LD := $(CROSS)/$(AARCH64)-ld
OBJCOPY := $(CROSS)/$(AARCH64)-objcopy
QEMU := qemu-system-aarch64

GCC_FLAGS = -Wall -O2 -ffreestanding -nostdinc -nostdlib -nostartfiles

SRCS = $(wildcard *.c)
OBJS = $(SRCS:.c=.o)

all: build

build: clean kernel8.img

boot.o: boot.S
	$(GCC) $(GCC_FLAGS) -c boot.S -o boot.o

%.o: %.c
	$(GCC) $(GCC_FLAGS) -c $< -o $@

kernel8.img: boot.o $(OBJS)
	$(LD) -nostdlib boot.o $(OBJS) -T linker.ld -o kernel8.elf
	$(OBJCOPY) -O binary kernel8.elf kernel8.img

run: build
	$(QEMU) -M raspi3b -kernel kernel8.img -serial null -serial stdio

clean:
	rm -f *.o *.elf *.img
