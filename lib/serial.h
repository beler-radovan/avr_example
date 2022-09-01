#ifndef SERIAL_H
#define SERIAL_H

#ifndef F_CPU
#warning F_CPU is not defined, setting default value 16MHz
#define F_CPU 16000000L
#endif

#define UBBR(baud) (F_CPU / 16 / baud) - 1

#define serial_send(a) _Generic((a), \
    char: serial_send_byte, \
    char *: serial_send_str, \
    int16_t: serial_send_int, \
    uint16_t: serial_send_uint \
    )(a)

#include <stdint.h>

void serial_init(uint16_t baud);
void serial_send_byte(uint8_t c);
void serial_send_str(char *s);
void serial_send_int(int16_t i);
void serial_send_uint(uint16_t ui);

#endif
