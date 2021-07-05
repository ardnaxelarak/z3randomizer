def process_values(sprite, values)
  ret = values.clone
  if [1, 2].include?(ret[0]) # boomerang
    ret[0] = 0
  end
  if ret[6] > 0 && sprite != 0x84 # bow and not red eyegore/mimic
    ret[6] = 0
  end
  if ret[7] == 2 # hookshot
    ret[7] = 1 # still want to stun
  end
  if ret[9] > 0 && sprite != 0x84 # silver bow and not red eyegore/mimic
    ret[9] = 0
  end
  if ret[10] == 4 # powder
    ret[10] = 0
  end
  if ret[11] > 0 && ![0xA1, 0xA3, 0xCD].include?(sprite) # fire rod
    ret[11] = 0
  end
  if ret[12] != 3 && sprite != 0xCC # ice rod
    ret[12] = 0
  end
  if ret[13] > 0 && ![0xA3, 0xA1].include?(sprite) # bombos
    ret[13] = 0
  end
  if ret[14] != 1 # ether
    ret[14] = 0
  end
  if ret[15] != 3 # quake
    ret[15] = 0
  end
  if sprite == 0x53 and ret[2] == 3
    ret[2] = 1 # armos knight? let's make master bombs not suck
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
  File.open("damage_table_sword_bombs.bin", "w") do |output|
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
