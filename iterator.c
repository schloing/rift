#include <stdio.h>
#include <stdint.h>

int main() {
    size_t   size = 32;
    uint32_t n    = 0;
    uint32_t index = 0;
    char buffer[2000];
    setvbuf(stdout, buffer, _IOFBF, sizeof(buffer));

    for (int i = 0; i < size; i++) {
        n |= 1 << i;
        printf("%u\n", n);

//      ZEROED
//      n &= ~(1 << i);
    }

    return 0;
}
