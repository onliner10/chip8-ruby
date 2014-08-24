class CPU

	# Ex9E - SKP Vx
	# Skip next instruction if key with the value of Vx is pressed.
	def opcode_EX9E(helper)
		self.PC += 2 if @keyboard.is_pressed?(helper.registry_X)
	end

	# ExA1 - SKNP Vx
	# Skip next instruction if key with the value of Vx is not pressed.
	def opcode_EXA1(helper)
		self.PC += 2 unless @keyboard.is_pressed?(helper.registry_X)
	end

end