CROSS_DIR := /opt/cross
SRC_DIR  := src
OBJ_DIR  := build
BIN_DIR  := bin

SRC_TYPES := -type f \( -iname "*.s" -o -iname "*.c" \)
SOURCES := $(shell find $(SRC_DIR)/* $(SRC_TYPES))
OBJECTS := $(foreach OBJECT, $(patsubst %.s, %.s.o, $(patsubst %.c, %.o, $(SOURCES))), $(OBJ_DIR)/$(OBJECT))

OS := kernel8
TARGET_ELF := $(BIN_DIR)/$(OS).elf
TARGET := $(BIN_DIR)/$(OS).img

AARCH64 := aarch64-none-elf
CROSS := $(CROSS_DIR)/gcc-arm-10.3-2021.07-x86_64-$(AARCH64)/bin

AS := $(CROSS)/$(AARCH64)-as
GCC := $(CROSS)/$(AARCH64)-gcc
GCC_FLAGS := -Wall -Wextra -O2 -ffreestanding -nostdlib -nostartfiles
LD := $(CROSS)/$(AARCH64)-ld
OBJCOPY := $(CROSS)/$(AARCH64)-objcopy
QEMU := qemu-system-aarch64
QEMU_FLAGS := -M raspi3b -kernel $(TARGET) -serial null -serial stdio

$(OBJ_DIR)/%.s.o: %.s
	@mkdir -p $(@D)
	$(AS) -c $< -o $@

$(OBJ_DIR)/%.o: %.c
	@mkdir -p $(@D)
	$(GCC) $(GCC_FLAGS) -c $< -o $@

$(TARGET): $(OBJECTS)
	@mkdir -p $(@D)
	$(LD) -nostdlib $(OBJECTS) -T linker.ld -o $(TARGET_ELF)
	$(OBJCOPY) -O binary $(TARGET_ELF) $(TARGET)

.PHONY:	.FORCE
.FORCE:

all: build

build: clean $(TARGET)

run: build
	$(QEMU) $(QEMU_FLAGS)

clean:
	rm -rf $(BIN_DIR)/* $(OBJ_DIR)/*

toolchain:
	@echo 'Setting up cross compiler...'
	curl -L 'https://developer.arm.com/-/media/Files/downloads/gnu-a/10.3-2021.07/binrel/gcc-arm-10.3-2021.07-x86_64-aarch64-none-elf.tar.xz' -o /tmp/gcc-arm-$(AARCH64).tar.xz
	sudo mkdir -p $(CROSS_DIR)
	sudo tar xf /tmp/gcc-arm-$(AARCH64).tar.xz -C $(CROSS_DIR)
