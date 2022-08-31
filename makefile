mcu:=atmega328p
freq:=16000000L
isp:=usbasp

output:=example
bin:=./bin/
lib:=./lib/
mkinc:=src/makefile.inc
obj:=
include $(mkinc)

elffile:=$(bin)/$(output).elf
ihexfile:=$(bin)/$(output).ihex

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
inc:=-I.
inc+=-I/usr/avr/include/

libs:=-L.
libs+=-L$(lib)

objcopy:=avr-objcopy
oflags:=-O ihex
oflags+=-R .eeprom

# Avrdude flags
aflags:=-v
aflags+=-p$(mcu)
aflags+=-c$(isp)
aflags+=-Pusb
aflags+=-Uflash:w:$(ihexfile):i

all: elf ihex

elf: $(obj)
	[[ -d $(bin) ]] || mkdir $(bin)
	$(cc) $(cflags) $(defs) $(inc) $^ -o $(elffile) $(libs)

%.o: %.c
	$(cc) $(cflags) $(defs) -c $< -o $@

ihex:
	$(objcopy) $(oflags) $(elffile) $(ihexfile)

up:
	[[ -f $(ihexfile) ]] && avrdude $(aflags) || echo -e "\n$(ihexfile) doesn't exist"

size:
	[[ -f $(elffile) ]] && avr-size -G $(elffile) || echo -e "\n$(elffile) doesn't exist"

.PHONY: clean
clean:
	rm -rf $(obj) $(bin)
