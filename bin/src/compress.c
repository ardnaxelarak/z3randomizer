#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include <sys/stat.h>

const int MAXLENGTH = 0x300;

struct section {
    int mode;
    int length;
    unsigned char data[2];
    int datalength;
};

int find_duplicate(off_t loc, off_t size, unsigned char buf[], struct section *out) {
    int i, j;
    struct section result;
    result.mode = 4;
    result.length = 0;
    for (i = 0; i < loc && i < 0x10000; i++) {
        if (buf[i] != buf[loc]) {
            continue;
        }
        for (j = 0; j < MAXLENGTH; j++) {
            if (buf[i + j] != buf[loc + j]) {
                break;
            }
        }
        if (j > result.length) {
            result.length = j;
            result.data[0] = i & 0xFF;
            result.data[1] = (i >> 8) & 0xFF;
            result.datalength = 2;
        }
    }
    if (result.length < 4) {
        return -1;
    }
    *out = result;
    return 0;
}

int find_repeat_byte(off_t loc, off_t size, unsigned char buf[], struct section *out) {
    int i;
    for (i = 0; i < MAXLENGTH && loc + i < size; i++) {
        if (buf[loc + i] != buf[loc]) {
            break;
        }
    }
    if (i > 2) {
        struct section result;
        result.mode = 1;
        result.length = i;
        result.data[0] = buf[loc];
        result.datalength = 1;
        *out = result;
        return 0;
    }
    return -1;
}

int find_repeat_word(off_t loc, off_t size, unsigned char buf[], struct section *out) {
    int i;
    for (i = 0; i < MAXLENGTH && loc + i + 1 < size; i += 1) {
        if (buf[loc + i] != buf[loc + (i & 1)]) {
            break;
        }
    }
    if (i > 3) {
        struct section result;
        result.mode = 2;
        result.length = i;
        result.data[0] = buf[loc];
        result.data[1] = buf[loc + 1];
        result.datalength = 2;
        *out = result;
        return 0;
    }
    return -1;
}

int find_incrementing_byte(off_t loc, off_t size, unsigned char buf[], struct section *out) {
    int i;
    for (i = 0; i < MAXLENGTH && loc + i < size; i++) {
        if (buf[loc] + i < i) {
            break;
        }
        if (buf[loc + i] != buf[loc] + i) {
            break;
        }
    }
    if (i > 2) {
        struct section result;
        result.mode = 3;
        result.length = i;
        result.data[0] = buf[loc];
        result.datalength = 1;
        *out = result;
        return 0;
    }
    return -1;
}

int get_section(off_t loc, off_t size, unsigned char buf[], struct section *out) {
    struct section best, current;
    best.length = 0;
    if (!find_repeat_byte(loc, size, buf, &current)) {
        if (current.length > best.length) {
            best = current;
        }
    }
    if (!find_repeat_word(loc, size, buf, &current)) {
        if (current.length > best.length) {
            best = current;
        }
    }
    if (!find_incrementing_byte(loc, size, buf, &current)) {
        if (current.length > best.length) {
            best = current;
        }
    }
    if (!find_duplicate(loc, size, buf, &current)) {
        if (current.length > best.length) {
            best = current;
        }
    }
    if (best.length > 0) {
        // printf("byte %06X: mode %d length %02X\n", loc, best.mode, best.length);
        *out = best;
        return 0;
    } else {
        return -1;
    }
}

int write_section(struct section section, unsigned char data[], unsigned char buf[], int loc) {
    int nloc = loc;
    int len = section.length - 1;
    if (len > 0x1F) {
      buf[nloc++] = 0xE0 | (section.mode << 2) | (len >> 8);
      buf[nloc++] = len & 0xFF;
    } else {
      buf[nloc++] = (section.mode << 5) | len;
    }
    for (int i = 0; i < section.datalength; i++) {
        buf[nloc++] = data[i];
    }
    return nloc;
}

int main(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: %s infile outfile [start [length]]\n", argv[0]);
        return 1;
    }

    off_t seek = 0;
    if (argc > 3) {
        seek = strtol(argv[3], NULL, 0);
    }

    FILE *inptr;
    if ((inptr = fopen(argv[1], "rb")) == NULL) {
        printf("%s does not exist.\n", argv[1]);
        return 1;
    }

    int fd = fileno(inptr);
    if (fd < 0) {
        printf("Error stating file: %s\n", argv[1]);
        return 1;
    }

    struct stat buf;
    if (fstat(fd, &buf) != 0) {
        printf("Error stating file: %s\n", argv[1]);
        return 1;
    }
    off_t size = buf.st_size - seek;

    if (argc > 4) {
        size = strtol(argv[4], NULL, 0);
    }
    unsigned char inbuf[size];

    fseek(inptr, seek, SEEK_SET);

    if (fread(inbuf, 1, size, inptr) < size) {
        printf("Error reading file: %s\n", argv[1]);
        return 1;
    }

    fclose(inptr);

    unsigned char outbuf[size * 2];
    unsigned char m0data[MAXLENGTH];

    int oloc = 0;
    struct section m0;
    m0.mode = 0;
    m0.length = 0;
    int i;

    off_t loc = 0;
    while (loc < size) {
        struct section section;
        if (!get_section(loc, size, inbuf, &section)) {
            if (m0.length > 0) {
                m0.datalength = m0.length;
                oloc = write_section(m0, m0data, outbuf, oloc);
                m0.length = 0;
            }
            oloc = write_section(section, section.data, outbuf, oloc);
            loc += section.length;
        } else {
            if (m0.length == MAXLENGTH) {
                m0.datalength = m0.length;
                oloc = write_section(m0, m0data, outbuf, oloc);
                m0.length = 0;
            }
            m0data[m0.length++] = inbuf[loc];
            loc += 1;
        }
    }

    if (m0.length > 0) {
        m0.datalength = m0.length;
        oloc = write_section(m0, m0data, outbuf, oloc);
        m0.length = 0;
    }

    outbuf[oloc++] = 0xFF;

    FILE *outptr;
    if ((outptr = fopen(argv[2], "wb")) == NULL) {
        printf("Error opening file: %s\n", argv[2]);
        return 1;
    }

    if (fwrite(outbuf, 1, oloc, outptr) < oloc) {
        printf("Error writing to file: %s\n", argv[2]);
        return 1;
    }

    fclose(outptr);
    printf("Input file: %lX bytes. Compressed: %X bytes.\n", size, oloc);

    return 0;
}
