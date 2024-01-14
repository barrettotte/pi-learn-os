AARCH64 := aarch64-none-elf
CROSS := /opt/cross/gcc-arm-10.3-2021.07-x86_64-$(AARCH64)/bin

AS := $(CROSS)/$(AARCH64)-as
GCC := $(CROSS)/$(AARCH64)-gcc
GCC_FLAGS := -Wall -O2 -ffreestanding -nostdlib -nostartfiles
LD := $(CROSS)/$(AARCH64)-ld
OBJCOPY := $(CROSS)/$(AARCH64)-objcopy
QEMU := qemu-system-aarch64

BIN_DIR  := bin
OBJ_DIR  := build
SRC_DIR  := .

OS := kernel8
TARGET := $(BIN_DIR)/$(OS).img

SRC_TYPES := -type f \( -iname "*.s" -o -iname "*.c" \)
SOURCES := $(shell find ./* $(SRC_TYPES))
OBJECTS := $(foreach OBJECT, $(patsubst %.s, %.s.o, $(patsubst %.c, %.o, $(SOURCES))), $(OBJ_DIR)/$(OBJECT))

$(OBJ_DIR)/%.s.o: %.s
	@mkdir -p $(@D)
	$(GCC) $(GCC_FLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: %.c
	@mkdir -p $(@D)
	$(GCC) $(GCC_FLAGS) -c $< -o $@

$(TARGET): $(OBJECTS)
	@mkdir -p $(@D)
	$(LD) -nostdlib $(OBJECTS) -T linker.ld -o $(BIN_DIR)/$(OS).elf
	$(OBJCOPY) -O binary $(BIN_DIR)/$(OS).elf $(TARGET)

.PHONY:	.FORCE
.FORCE:

all: build

build: clean $(TARGET)

run: build
	$(QEMU) -M raspi3b -kernel $(TARGET) -serial null -serial stdio

clean:
	rm -rf $(BIN_DIR)/* $(OBJ_DIR)/*
