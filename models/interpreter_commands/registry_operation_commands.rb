class Interpreter
	#Set Vx = kk.
	def opcode_6XKK(helper)
		helper.registry_X = helper.var_K
	end

	#Set Vx = Vx + kk.
	def opcode_7XKK(helper)
		helper.registry_X += helper.var_K
	end

	# Set Vx = Vy.
	def opcode_8XY0(helper)
		helper.registry_X = helper.registry_Y
	end

	# Set Vx = Vx OR Vy.
	def opcode_8XY1(helper)
		helper.registry_X = helper.registry_X | helper.registry_Y
	end


	# Set Vx = Vx AND Vy.
	def opcode_8XY2(helper)
		helper.registry_X = helper.registry_X & helper.registry_Y
	end

	# Set Vx = Vx XOR Vy.
	def opcode_8XY3(helper)
		helper.registry_X = helper.registry_X ^ helper.registry_Y
	end

	# Set Vx = Vx + Vy.
	#if result > 255 set VF to 1 (carry flag) otherwise set to 0
	def opcode_8XY4(helper)
		result = helper.registry_X + helper.registry_Y

		if result > 255
			self.VF = 1
		else
			self.VF = 0
		end	

		helper.registry_X = result
	end

	# Set Vx = Vx - Vy.
	# If Vx > Vy, then VF is set to 1, otherwise 0. Then Vy is subtracted from Vx, and the results stored in Vx.
	def opcode_8XY5(helper)
		result = (helper.registry_X - helper.registry_Y).abs

		if(helper.registry_X > helper.registry_Y)
			self.VF = 1
		else
			self.VF = 0
		end

		helper.registry_X = result
	end

	# Set Vx = Vx SHR 1.
	#If the least-significant bit of Vx is 1, then VF is set to 1, otherwise 0. Then Vx is divided by 2.
	def opcode_8XY6(helper)
		binary = helper.registry_X.to_s(2)

		self.VF = binary.split('').last.to_i
		helper.registry_X = helper.registry_X / 2
	end

	# Set Vx = Vy - Vx, set VF = NOT borrow.
	# If Vy > Vx, then VF is set to 1, otherwise 0. Then Vx is subtracted from Vy, and the results stored in Vx.
	def opcode_8XY7(helper)
		if(helper.registry_Y > helper.registry_X)
			self.VF = 1
		else
			self.VF = 0
		end

		helper.registry_X = (helper.registry_Y - helper.registry_X).abs
	end

	# Set Vx = Vx SHL 1.
	# If the most-significant bit of Vx is 1, then VF is set to 1, otherwise to 0. Then Vx is multiplied by 2.
	def opcode_8XYE(helper)
		most_significant_bit = helper.registry_X >> 7

		self.VF = most_significant_bit
		helper.registry_X = helper.registry_X * 2
	end

	def opcode_ANNN(helper)
		self.I = helper.var_N
	end

	#generates random value
	def opcode_CXKK(helper)
		helper.registry_X = Random.rand(0..255) & helper.var_K
	end

	# Store BCD (hundreds/tens/ones) representation of Vx in memory locations I, I+1, and I+2.
	def opcode_FX33(helper)
		value = helper.registry_X
		
		@memory.load(self.I, value / 100)
		@memory.load(self.I + 1, (value / 10) % 10)
		@memory.load(self.I + 2, value % 10)
	end
end