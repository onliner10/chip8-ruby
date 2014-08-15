class Memory

	def initialize
		@ram = Array.new(4096)
	end

	def load(start_pointer, content)
		end_pointer = start_pointer + content.size
		pointer = start_pointer

		while (pointer < end_pointer)
			@ram[pointer] = content[pointer]
			pointer += 1
		end
	end

end