#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <string.h>

#include "test_vectors.h"

uint32_t XXH32(const void *input, size_t length, uint32_t seed);

int main(int argc, char *argv[])
{
    const uint8_t *data = s5;     // default scenario
    size_t len = s5_len;
    char str[3];
    strcpy(str, "s5");

    if (argc > 1) {
        strcpy(str, argv[1]);
        if (!strcmp(argv[1], "s1")) {
            data = s1; len = s1_len;
        } 
        else if (!strcmp(argv[1], "s2")) {
            data = s2; len = s2_len;
        } 
        else if (!strcmp(argv[1], "s3")) {
            data = s3; len = s3_len;
        } 
        else if (!strcmp(argv[1], "s4")) {
            data = s4; len = s4_len;
        } 
        else if (!strcmp(argv[1], "s5")) {
            data = s5; len = s5_len;
        } 
        else {
            printf("Unknown scenario, defaulting to s5\n");
            strcpy(str, "s5");
        }
    }

    uint32_t hash = XXH32(data, len, 0);

    printf("Resulting Hash for %s = 0x%08X\n", str, hash);
    printf("Input Size: %d Bytes. \n", len);

    return 0;
}