mcu:=atmega328p
freq:=16000000L
isp:=usbasp

output:=example
src:=$(output).c blink.c
obj:=$(src:.c=.o)

# Compiler flags
cc:=avr-gcc
cflags:=-std=c11
cflags+=-Wall
cflags+=-Werror
cflags+=-Os
cflags+=-mmcu=$(mcu)
cflags+=-ffunction-sections -fdata-sections
cflags+=-Wl,--gc-sections,--print-gc-sections
# -Os -> optimize for size
# -ffunction-sections -fdata-sections -> necessary for --gc-sections
# -Wl -> linker options
# --gc-sections -> tell linker to drop unused functions and data sections
# --print-gc-sections -> print dropped sections

# Macro definitions
defs:=-DF_CPU=$(freq)

# Includes
inc:=-I/usr/avr/include/

libs:=-L.

oflags:=-O ihex
oflags+=-R .eeprom

# Avrdude flags
aflags:=-v
aflags+=-p$(mcu)
aflags+=-c$(isp)
aflags+=-Pusb
aflags+=-Uflash:w:$(output).ihex:i

all: elf ihex

elf: $(obj)
	$(cc) $(cflags) $(defs) $(inc) $^ -o $(output).elf $(libs)

%.o: %.c
	$(cc) $(cflags) $(defs) -c $< -o $@

ihex:
	avr-objcopy $(oflags) $(output).elf $(output).ihex

up:
	avrdude $(aflags)

size:
	[[ -f $(output).elf ]] && avr-size -G $(output).elf || echo "$(output).elf doesn't exist"

.PHONY: clean
clean:
	rm -rf $(output).ihex $(output).elf $(obj)
