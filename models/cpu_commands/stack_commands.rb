class CPU
	def opcode_00EE(helper)
		self.PC = @stack.pop
	end

	def opcode_2NNN(helper)
		@stack.push(self.PC)
		self.PC = helper.var_K
	end
end