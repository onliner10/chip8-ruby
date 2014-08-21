require "./models/memory"

class CpuTestHelper
	def self.memory_with_single_opcode(opcode)
	    memory = Memory.new

	    memory.load("200".hex, opcode[0..1].to_i(16))
	    memory.load("201".hex, opcode[2..3].to_i(16))

	    memory
	end
end