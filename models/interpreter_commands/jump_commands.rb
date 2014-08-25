class Interpreter
	#jump to nnn
	def opcode_1XXX(helper)
		self.PC = helper.var_X
	end

	# Jump to location nnn + V0.
	def opcode_BNNN(helper)
		self.PC = helper.var_N + self.V0
	end	

	#Skip next instruction if Vx = kk.
	def opcode_3XKK(helper)
		self.PC += 2 if helper.registry_X == helper.var_K
	end

	#Skip next instruction if Vx != kk.
	def opcode_4XKK(helper)
		self.PC += 2 unless helper.registry_X == helper.var_K
	end

	#Skip next instruction if Vx = Vy.
	def opcode_5XY0(helper)
		self.PC += 2 if helper.registry_X == helper.registry_Y
	end

	# Skip next instruction if Vx != Vy.
	def opcode_9XY0(helper)
		self.PC += 2 if helper.registry_X != helper.registry_Y
	end
end