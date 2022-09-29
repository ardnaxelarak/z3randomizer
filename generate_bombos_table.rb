def process_values(sprite, values)
  ret = values.clone
  case sprite
    when 0x09, 0x53, 0x54, 0x88 # moldorm, armos knights, lanmola, mothula
      ret[13] = 1 # bombos - 16 damage
    when 0x83, 0x84, 0x91, 0xC3 # green and red eyegores, stalfos knight, gibo
      ret[13] = 1 # bombos - 16 damage
    when 0x8C, 0x92 # arrghus, helmasaur king
      ret[13] = 2 # bombos - 64 damage
    when 0xBD # vitreous big eye
      ret[13] = 2 # bombos - 64 damage
    when 0x8D, 0xBE, 0xA2 # arrghus puff, vitreous small eye, kholdstare puffs
      ret[13] = 1 # bombos - 16 damage
    when 0xCB, 0xCC, 0xCD # trinexx, firenexx, icenexx
      ret[13] = 2 # bombos - 64 damage
    when 0xD0 # lynel
      ret[13] = 1 # bombos - 16 damage
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
  File.open("damage_table_bombos.bin", "w") do |output|
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

