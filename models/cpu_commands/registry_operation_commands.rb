class CPU
	#jump to nnn
	def opcode_1XXX(helper)
		self.PC = helper.var_X
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
			result = result % 255
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
end