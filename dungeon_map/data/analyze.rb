File.open("supertile_shapes.asm", "r") do |file|
  bytes = []
  while line = file.gets
    m = line.match(/dw \$(\h+), \$(\h+), \$(\h+), \$(\h+)/)
    bytes += m.captures if m
    break if bytes.length >= 4 * 0xE0
  end

  counts = []
  for byte in bytes do
    value = byte.to_i(16)
    next if value == 0xFFFF
    value = (value & 0x03FF) - 0x340
    if not counts[value]
      counts[value] = 0
    end
    counts[value] += 1
  end

  print("  ")
  for col in 0...16
    printf("  x%X", col)
  end
  puts

  for row in 0...8
    printf("%Xx", row)
    for col in 0...16
      printf("%4d", counts[row * 16 + col] || 0)
    end
    puts
  end

  printf("Unused:")
  for i in 0...0x80
    printf(" %2X", i) unless counts[i]
  end
  puts
end
