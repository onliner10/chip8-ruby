class Display
	def self.sprites
		binaryFile = File.binread("./models/assets/sprites.hex")
		binaryFile.unpack("C*")
	end

	def self.sprite_offset_for(digit)
		digit * 5
	end

	def draw_sprite(sprite, position = {})
		raise ArgumentError.new("Coordinates outside of display (64x32)") if position[:x] > 63 || position[:y] > 31

		col = position[:x]
		row = position[:y]

		any_erased = 0

		sprite.each_slice(8) do |byte|
			byte.each do |bit| 
				any_erased = 1 if buffer[row][col] & bit == 1

				buffer[row][col] = buffer[row][col] ^ bit 
				col += 1

				col = 0 if col > 63
			end
			col = position[:x]

			row += 1
			row = 0 if row > 31
		end

		any_erased
	end

	def clear
		32.times do |row|
			64.times {|col| buffer[row][col] = 0}
		end
	end

	def buffer
		@buffer ||= Array.new(32) { |row| Array.new(64) { |col| 0} }
	end
end