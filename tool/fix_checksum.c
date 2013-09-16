/**
* \file fix_checksum.c
* \brief fix binary's checksum for LPC11xx/LPC13xx/LPC17xx
*/

#include <stdint.h>
#include <stdio.h>

int main(int argc, char **argv)
{
    int i;
    FILE *fd = NULL;
    uint32_t buf[8];
    uint32_t sum;
    uint32_t result;
    int r;

    if (argc == 1) {
        printf("Usage: %s BINARY\n", argv[0]);
        return -1;
    } else if (argc > 2) {
        printf("Too many arguments\n");
        printf("Usage: %s BINARY\n", argv[0]);
        return -2;
    }

    fd = fopen(argv[1], "rb+");
    if (fd == NULL) {
        printf("Failed to open %s.\n", argv[1]);
        return -3;
    }

    r = fread(buf, sizeof(uint32_t), 7, fd);
    if (r != 7) {
        printf("The file - %s is too short.\n", argv[1]);
        fclose(fd);
        return -4;
    }

    sum = 0;
    for (i=0; i<7; i++) {
        sum += buf[i];
    }

    result = ~sum + 1;

    fseek(fd, sizeof(uint32_t) * 7, SEEK_SET);
    r = fwrite(&result, sizeof(uint32_t), 1, fd);
    if (r != 1) {
        printf("Failed to write file.\n");
        fclose(fd);
        return -5;
    }

    fclose(fd);

    return 0;
}