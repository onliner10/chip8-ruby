class Interpreter

	def opcode_FX07(helper)
		helper.registry_X = self.DT.value
	end

	def opcode_FX15(helper)
		self.DT.set(helper.registry_X)
	end

	def opcode_FX18(helper)
		self.ST.set(helper.registry_X)
	end
end