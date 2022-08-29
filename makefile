mcu=atmega328p
freq=16000000L
isp=usbasp

output=example
src=$(output).c blink.c
obj=$(src:.c=.o)

# Compiler flags
cc=avr-gcc
cflags+=-std=c11
cflags+=-Wall -Werror
cflags+=-Os
cflags+=-mmcu=$(mcu)
cflags+=-ffunction-sections -fdata-sections
cflags+=-Wl,--gc-sections
# -Os -> optimize for size
# -ffunction-sections -fdata-sections -> necessary for -Wl,--gc-sections
# -Wl,--gc-sections -> tell linker to drop unused functions and data sections

# Macro definitions
defs+=-DF_CPU=$(freq)

# Includes
inc+=/usr/avr/include/

oflags+=-O ihex
oflags+=-R .eeprom

# Avrdude flags
aflags+=-v
aflags+=-p$(mcu)
aflags+=-c$(isp)
aflags+=-Pusb
aflags+=-Uflash:w:$(output).ihex:i

all: elf ihex

elf: $(obj)
	$(cc) $(cflags) $(defs) $^ -o $(output).elf

%.o: %.c
	$(cc) $(cflags) $(defs) -c $< -o $@

ihex:
	avr-objcopy $(oflags) $(output).elf $(output).ihex

up:
	avrdude $(aflags)

.PHONY: clean
clean:
	rm -rf $(output).ihex $(output).elf $(obj)
