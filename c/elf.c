#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

#define ERR_HELP_USAGE              "usage: rift [ELF source]\n"
#define ERR_NUMBER_ARGS             "expected argument, received none\n"
#define ERR_FILE_OPEN_FAIL          "failed to open file %s\n"
#define ERR_MAGIC_NUMBER_NO_MATCH   "expected ELF executable: magic numbers did not match\n"

#define error(fmt, ...) fprintf(stderr, fmt, ##__VA_ARGS__)

void terminate(int code) {
    // cleanup
    exit(code);
}

void verify_elf(FILE* elf) {
#define header_size 4;

    const char magic[header_size]  = { 0x7f, 'E', 'L', 'F' };
    char       header[header_size] = { 0 };

    pread(fileno(elf), header, 4, 0);

    for (int i = 0; i < 4; i++)
        if (magic[i] != header[i]) {
            error(ERR_MAGIC_NUMBER_NO_MATCH);
            terminate(EXIT_FAILURE);
        }
}

int main(int argc, char** argv) {
    if (argc < 2) {
        error(ERR_HELP_USAGE);
        error(ERR_NUMBER_ARGS);

        terminate(EXIT_FAILURE);
    }
    
    FILE* elf;

    if ((elf = fopen(argv[1], "rb")) == NULL) {
        error(ERR_FILE_OPEN_FAIL, argv[1]);
        terminate(EXIT_FAILURE);
    }

    verify_elf(elf); // terminates if not ELF

    fclose(elf);
    return 0;
}
