class Interpreter

	# Display n-byte sprite starting at memory location I at (Vx, Vy), set VF = collision.
	def opcode_DXYN(helper)
		sprite = @memory.range_bits(self.I, self.I + (helper.var_N-1 ) )
		@display.draw_sprite(sprite, :x => helper.registry_X, :y => helper.registry_Y)
	end

	# Clears the screen
	def opcode_00E0(helper)
		@display.clear
	end

end