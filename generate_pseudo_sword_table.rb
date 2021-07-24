def process_values(sprite, values)
  ret = values.clone
  if (ret[1] == 0 && sprite != 0x40) || sprite == 0xCE
    # fighter sword does no damage and it's not the evil barrier, or it's Blind
    ret[5] = 0
  end
  return ret
end

def split_value(byte)
  return [byte >> 4, byte & 0x0F]
end

def join_values(value1, value2)
  return (value1 & 0x0F) << 4 | (value2 & 0x0F)
end

File.open("damage_table.bin") do |input|
  File.open("damage_table_pseudo_sword.bin", "w") do |output|
    i_enum = input.each_byte
    (0...0xD7).each do |sprite|
      values = []
      (0...8).each do
        values += split_value(i_enum.next)
      end
      v_enum = process_values(sprite, values).to_enum
      (0...8).each do
        output.putc(join_values(v_enum.next, v_enum.next))
      end
    end
    begin
      while true
        output.putc(i_enum.next)
      end
    rescue StopIteration
    end
  end
end
