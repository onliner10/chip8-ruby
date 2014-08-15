class CPU

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

	end
end