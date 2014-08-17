class CPU

	#1nnn
	#jump to nnn
	def opcode_1XXX(opcode)
		jmp_address = opcode[1..3].to_i(16)

		self.PC = jmp_address
	end

	#3xkk
	#Skip next instruction if Vx = kk.
	def opcode_3XXX(opcode)
		registryNumber = opcode[1]
		registryExpectedValue = opcode[2..3].to_i(16)

		registryValue = send("V#{registryNumber}")

		self.PC += 2 if registryValue == registryExpectedValue
	end

	#4xkk
	#Skip next instruction if Vx != kk.
	def opcode_4XXX(opcode)
		registryNumber = opcode[1]
		registryExpectedValue = opcode[2..3].to_i(16)

		registryValue = send("V#{registryNumber}")

		self.PC += 2 unless registryValue == registryExpectedValue
	end

	#5xy0
	#Skip next instruction if Vx = Vy.
	def opcode_5XX0(opcode)
		registryNumber1 = opcode[1]
		registryNumber2 = opcode[2]
		
		registryValue1 = send("V#{registryNumber1}")
		registryValue2 = send("V#{registryNumber2}")

		self.PC += 2 if registryValue1 == registryValue2
	end

	#6xkk
	#Set Vx = kk.
	def opcode_6XXX(opcode)
		registryNumber = opcode[1]
		valueToSet = opcode[2..3].to_i(16)

		send("V#{registryNumber}=", valueToSet)
	end

	#7xkk
	#Set Vx = Vx + kk.
	def opcode_7XXX(opcode)
		registryNumber = opcode[1]
		incrementBy = opcode[2..3].to_i(16)

		registryValue = send("V#{registryNumber}")
		send("V#{registryNumber}=", registryValue + incrementBy)
	end

	#8xy0
	# Set Vx = Vy.
	def opcode_8XX0(opcode)
		registryToSet = opcode[1]
		registryToCopyFrom = opcode[2]

		registryToCopyFromValue = send("V#{registryToCopyFrom}")
		send("V#{registryToSet}=", registryToCopyFromValue)
	end

	#8xy1
	# Set Vx = Vx OR Vy.
	def opcode_8XX1(opcode)
		registerToSet = opcode[1]
		registerToDoBitwiseOr = opcode[2]

		registerToSetValue = send("V#{registerToSet}")
		registerToDoBitwiseOrValue = send("V#{registerToDoBitwiseOr}")

		valueToSet = registerToSetValue | registerToDoBitwiseOrValue
		send("V#{registerToSet}=", valueToSet)
	end

	#8xy2
	# Set Vx = Vx AND Vy.
	def opcode_8XX2(opcode)
		registerToSet = opcode[1]
		registerToDoBitwiseAnd = opcode[2]

		registerToSetValue = send("V#{registerToSet}")
		registerToDoBitwiseAndValue = send("V#{registerToDoBitwiseAnd}")

		valueToSet = registerToSetValue & registerToDoBitwiseAndValue
		send("V#{registerToSet}=", valueToSet)
	end

	#8xy3
	# Set Vx = Vx XOR Vy.
	def opcode_8XX3(opcode)
		registerToSet = opcode[1]
		registerToDoBitwiseXor = opcode[2]

		registerToSetValue = send("V#{registerToSet}")
		registerToDoBitwiseXorValue = send("V#{registerToDoBitwiseXor}")

		valueToSet = registerToSetValue ^ registerToDoBitwiseXorValue
		send("V#{registerToSet}=", valueToSet)
	end

	#8xy4
	# Set Vx = Vx + Vy.
	#if result > 255 set VF to 1 (carry flag) otherwise set to 0
	def opcode_8XX4(opcode)
		registerToSet = opcode[1]
		registerToAdd = opcode[2]

		registerToSetValue = send("V#{registerToSet}")
		registerToAddValue = send("V#{registerToAdd}")

		result = registerToSetValue + registerToAddValue

		if result > 255
			self.VF = 1
			result = result % 255
		else
			self.VF = 0
		end	

		send("V#{registerToSet}=", result)
	end

	#8xy5
	# Set Vx = Vx - Vy.
	# If Vx > Vy, then VF is set to 1, otherwise 0. Then Vy is subtracted from Vx, and the results stored in Vx.
	def opcode_8XX5(opcode)
		registerToSet = opcode[1]
		registerToSubstract = opcode[2]

		registerToSetValue = send("V#{registerToSet}")
		registerToSubstractValue = send("V#{registerToSubstract}")

		result = registerToSetValue + registerToAddValue

		if result > 255
			self.VF = 1
			result = result % 255
		else
			self.VF = 0
		end	

		send("V#{registerToSet}=", result)
	end
end