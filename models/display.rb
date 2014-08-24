class Display
	def draw_sprite(sprite, position = {})
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

	def buffer
		@buffer ||= Array.new(32) { |row| Array.new(64) { |col| 0} }
	end
end