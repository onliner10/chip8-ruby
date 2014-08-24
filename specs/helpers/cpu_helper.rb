require "./models/memory"

class CpuTestHelper
	def self.memory_with_single_opcode(opcode)
	    memory = Memory.new

	    memory.load("200".hex, opcode[0..1].to_i(16))
	    memory.load("201".hex, opcode[2..3].to_i(16))

	    memory
	end

	def self.keyboard_mock()
		keyboard_mock = Class.new do
			def initialize
				@pressed = []
			end

			def press(key)
				@pressed.push(key)
			end

			def is_pressed?(key)
				if(@pressed.include?(key))
					return true
				end

				false
			end
	    end

	    keyboard_mock.new
	end
end