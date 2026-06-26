# Fallback path if DEVKITPRO environment variable is not explicitly exported
DEVKITPRO ?= /opt/devkitpro

include $(DEVKITPRO)/devkitA64/base_rules

TARGET := custom_bootloader

# Hardware compiler optimization flags for Tegra X1 (Cortex-A57)
ARCH    := -march=armv8-a+crc+crypto -mtune=cortex-a57 -mstrict-align
CFLAGS  := $(ARCH) -O2 -Wall -ffreestanding -fno-builtin -fomit-frame-pointer -fno-common -fPIE
ASFLAGS := $(ARCH)

# Linker flags to generate a flat bare-metal binary layout
LDFLAGS := -specs=$(DEVKITPRO)/devkitA64/base_specs -pie -N -Ttext 0x40010000 -nostdlib

CC      := aarch64-none-elf-gcc
OBJCOPY := aarch64-none-elf-objcopy

.PHONY: all clean

all: $(TARGET).bin

$(TARGET).elf: main.o
	$(CC) $(LDFLAGS) main.o -o $@

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -v -O binary $< $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o *.elf *.bin
