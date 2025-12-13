import sys

def decompress(compressed_data):
    out = bytearray()
    i = 0
    
    while i < len(compressed_data):
        cmd = compressed_data[i]
        
        if cmd == 0xFF:
            # End marker
            break
        
        i += 1
        
        # Decode based on top 3 bits
        top_bits = cmd & 0xE0
        
        if cmd < 0xE0:
            # Standard commands
            length = (cmd & 0x1F) + 1
            
            if top_bits == 0x00:
                # Raw copy
                out.extend(compressed_data[i:i+length])
                i += length
            elif top_bits == 0x20:
                # Repeating byte
                byte_val = compressed_data[i]
                out.extend([byte_val] * length)
                i += 1
            elif top_bits == 0x40:
                # Repeating word - alternates between two bytes
                byte_a = compressed_data[i]
                byte_b = compressed_data[i+1]
                for j in range(length):
                    if j % 2 == 0:
                        out.append(byte_a)
                    else:
                        out.append(byte_b)
                i += 2
            elif top_bits == 0x60:
                # Incremental
                start_val = compressed_data[i]
                for j in range(length):
                    out.append((start_val + j) & 0xFF)
                i += 1
            elif top_bits >= 0x80:
                # Copy from past (absolute offset)
                offset = compressed_data[i] | (compressed_data[i+1] << 8)
                for j in range(length):
                    out.append(out[offset + j])
                i += 2
        else:
            # Extended command (0xE0-0xFE)
            # Command type from bits 5-7 (after shifting)
            cmd_type = ((cmd << 3) & 0xE0)
            # Length from bits 0-1 of command (high) + next byte (low)
            length_high = cmd & 0x03
            length_low = compressed_data[i]
            length = (length_high << 8) | length_low
            length += 1
            i += 1
            
            if cmd_type == 0x00:
                # Extended raw copy
                out.extend(compressed_data[i:i+length])
                i += length
            elif cmd_type == 0x20:
                # Extended repeating byte
                byte_val = compressed_data[i]
                out.extend([byte_val] * length)
                i += 1
            elif cmd_type == 0x40:
                # Extended repeating word - alternates between two bytes
                byte_a = compressed_data[i]
                byte_b = compressed_data[i+1]
                for j in range(length):
                    if j % 2 == 0:
                        out.append(byte_a)
                    else:
                        out.append(byte_b)
                i += 2
            elif cmd_type == 0x60:
                # Extended incremental
                start_val = compressed_data[i]
                for j in range(length):
                    out.append((start_val + j) & 0xFF)
                i += 1
            elif cmd_type >= 0x80:
                # Extended copy from past
                offset = compressed_data[i] | (compressed_data[i+1] << 8)
                for j in range(length):
                    out.append(out[offset + j])
                i += 2
    
    return out

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python decompress.py <input_file> <output_file>")
        sys.exit(1)
    
    with open(sys.argv[1], 'rb') as f:
        compressed = f.read()
    
    decompressed = decompress(compressed)
    
    with open(sys.argv[2], 'wb') as f:
        f.write(decompressed)
    
    print(f"Decompressed {len(compressed)} bytes to {len(decompressed)} bytes")
