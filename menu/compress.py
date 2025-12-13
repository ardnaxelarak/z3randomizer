import sys
import os

# Compression function reverse-engineered from ALTTP's decompression routine at $00E7DE
def compress(data):
    out = bytearray()
    i = 0
    
    while i < len(data):
        # Check for repeating byte pattern
        if i + 1 < len(data) and data[i] == data[i + 1]:
            length = 2
            while i + length < len(data) and data[i] == data[i + length] and length < 32:
                length += 1
            # Repeating byte: 0x20-0x3F
            out.append(0x20 | (length - 1))
            out.append(data[i])
            i += length
            continue
        
        # Check for incremental byte pattern
        if i + 2 < len(data) and data[i + 1] == data[i] + 1 and data[i + 2] == data[i] + 2:
            length = 3
            while i + length < len(data) and data[i + length] == data[i] + length and length < 32:
                length += 1
            # Incremental: 0x60-0x7F
            out.append(0x60 | (length - 1))
            out.append(data[i])
            i += length
            continue
        
        # Check for repeating word pattern (alternating two bytes)
        if i + 3 < len(data):
            # Check if we have an alternating pattern: A B A B...
            byte_a = data[i]
            byte_b = data[i + 1]
            length = 2
            while i + length < len(data) and length < 32:
                if length % 2 == 0:
                    if data[i + length] != byte_a:
                        break
                else:
                    if data[i + length] != byte_b:
                        break
                length += 1
            
            if length >= 4:  # Need at least 4 bytes (2 alternations) to make it worthwhile
                # Repeating word: 0x40-0x5F
                out.append(0x40 | (length - 1))
                out.append(byte_a)
                out.append(byte_b)
                i += length
                continue
        
        # Check for copy from past (LZ with absolute offset)
        best_len = 0
        best_off = 0
        search_start = max(0, i - 65536)  # Can reference anywhere in output
        for j in range(search_start, i):
            length = 0
            while i + length < len(data) and data[j + length] == data[i + length] and length < 1024:
                length += 1
            if length >= 2 and length > best_len:
                best_len = length
                best_off = j  # Absolute offset, not relative!
        
        if best_len >= 2:
            # Copy from past: 0x80-0xDF or 0xE0-0xFE (extended)
            # Offset is ABSOLUTE position in the output buffer
            if best_len <= 32:
                # Standard copy: 0x80-0xDF (5 bits for length-1, 16 bits for absolute offset)
                out.append(0x80 | ((best_len - 1) & 0x1F))
                out.append(best_off & 0xFF)
                out.append((best_off >> 8) & 0xFF)
            else:
                # Extended copy: 0xE0-0xFE
                if best_len > 1024:
                    best_len = 1024
                # Command byte: 111LLLLL where L is length bits
                cmd = 0xE0 | (((best_len - 1) >> 8) & 0x1F)
                out.append(cmd)
                out.append((best_len - 1) & 0xFF)
                out.append(best_off & 0xFF)
                out.append((best_off >> 8) & 0xFF)
            i += best_len
            continue
        
        # Raw copy (no pattern found)
        size = 1
        while size < 32 and i + size < len(data):
            # Don't extend raw copy if we find a better pattern ahead
            if i + size + 1 < len(data) and data[i + size] == data[i + size + 1]:
                break
            if i + size + 2 < len(data) and data[i + size + 1] == data[i + size] + 1:
                break
            # Check LZ
            found_lz = False
            for j in range(max(0, i + size - 2048), i + size):
                if i + size + 1 < len(data) and data[j] == data[i + size] and data[j + 1] == data[i + size + 1]:
                    found_lz = True
                    break
            if found_lz:
                break
            size += 1
        
        # Raw copy: 0x00-0x1F
        out.append(size - 1)
        out.extend(data[i:i + size])
        i += size
    
    # End marker
    out.append(0xFF)
    return out

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python compress.py <input_file> <output_file>")
        sys.exit(1)

    input_file_path = sys.argv[1]
    output_file_path = sys.argv[2]

    if not os.path.exists(input_file_path):
        print(f"Error: Input file not found at {input_file_path}")
        sys.exit(1)

    with open(input_file_path, 'rb') as f:
        input_data = f.read()

    compressed_data = compress(input_data)

    with open(output_file_path, 'wb') as f:
        f.write(compressed_data)

    print(f"Successfully compressed '{input_file_path}' to '{output_file_path}'")
