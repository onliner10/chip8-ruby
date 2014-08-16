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

	#6xkk
	#Set Vx = kk.
	def opcode_6XXX(opcode)
		registryNumber = opcode[1]
		valueToSet = opcode[2..3].to_i(16)

		send("V#{registryNumber}=", valueToSet)
	end

	#8xy0
	# Set Vx = Vy.
	def opcode_8XX0(opcode)
		registryToSet = opcode[1]
		registryToCopyFrom = opcode[2]

		registryToCopyFromValue = send("V#{registryToCopyFrom}")
		send("V#{registryToSet}=", registryToCopyFromValue)
	end
end