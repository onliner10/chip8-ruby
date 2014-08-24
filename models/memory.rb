class Memory

	def initialize
		@ram = Array.new(4096)
	end

	def load(start_pointer, content)
		if(false == content.respond_to?(:length))
			@ram[start_pointer] = content
			return
		end

		end_pointer = start_pointer + content.length 
		pointer = start_pointer

		while (pointer < end_pointer)
			@ram[pointer] = content[pointer]
			pointer += 1
		end
	end

	def instruction_at(address)
		instruction = (@ram[address] << 8) + @ram[address + 1]
		(instruction.to_s(16).rjust(4, '0')).upcase
	end

	def byte_at(address)
		@ram[address]
	end

	def range(from, to)
		result = []
		from.upto(to) { |addr| result.push(@ram[addr])}

		result
	end

end