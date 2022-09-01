#include "blink.h"
#include "serial.h"
#include <stdint.h>

int main() {
    serial_init(9600);

    for (;;) {
        blink();
        serial_send("hello\n\r");
        serial_send((char)'a');
    }

    return 0;
}
