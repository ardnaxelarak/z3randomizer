#include <stdio.h>
#include <stddef.h>
#include <sys/stat.h>

struct section {
    int mode;
    int length;
    char data[2];
    int datalength;
};

int read_section(char buf[], int loc, struct section *out) {
    int nloc = loc;
    char header = buf[nloc++];

    printf("%x: ", header & 0xff);

    if (header == -1) {
      return -1;
    }

    struct section result;
    result.data[0] = buf[loc];
    result.datalength = 1;

    if ((header & 0xE0) == 0xE0) {
      result.mode = (header & 0x1C) >> 2;
      result.length = (((header & 0x03) << 8) | buf[nloc++]) + 1;
    } else {
      result.mode = (header & 0xE0) >> 5;
      result.length = (header & 0x1F) + 1;
    }

    printf("%d: %x\n", result.mode, result.length);

    switch (result.mode) {
      case 0:
        result.datalength = 0;
        break;
      case 1:
        result.datalength = 1;
        break;
      case 2:
        result.datalength = 2;
        break;
      case 3:
        result.datalength = 1;
        break;
      case 4:
        result.datalength = 2;
        break;
    }

    for (int i = 0; i < result.datalength; i++) {
      result.data[i] = buf[nloc++];
    }

    *out = result;
    return nloc;
}

int main(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: %s infile outfile\n", argv[0]);
        return 1;
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
    off_t size = buf.st_size;

    char inbuf[size];

    if (fread(inbuf, 1, size, inptr) < size) {
        printf("Error reading file: %s\n", argv[1]);
        return 1;
    }

    fclose(inptr);

    char outbuf[size * 256];

    int oloc = 0;
    struct section section;
    int i;

    off_t loc = 0;

    while ((loc = read_section(inbuf, loc, &section)) >= 0) {
      if (section.mode == 0) {
        for (i = 0; i < section.length; i++) {
          outbuf[oloc++] = inbuf[loc++];
        }
      } else if (section.mode == 1) {
        for (i = 0; i < section.length; i++) {
          outbuf[oloc++] = section.data[0];
        }
      } else if (section.mode == 2) {
        for (i = 0; i < section.length; i++) {
          outbuf[oloc++] = section.data[0];
          if (++i < section.length) {
            outbuf[oloc++] = section.data[1];
          }
        }
      } else if (section.mode == 3) {
        for (i = 0; i < section.length; i++) {
          outbuf[oloc++] = (section.data[0] + i) & 0xff;
        }
      } else if (section.mode == 4) {
        int offset = section.data[0] | (section.data[1] << 8);
        for (i = 0; i < section.length; i++) {
          outbuf[oloc++] = outbuf[offset + i];
        }
      }
    }

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
    printf("Input file: %X bytes. Decompressed: %X bytes.\n", size, oloc);

    return 0;
}
