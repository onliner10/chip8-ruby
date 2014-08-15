class Memory

	def initialize
		@ram = Array.new(4096)
	end

	def load(start_pointer, content)
		end_pointer = start_pointer + content.length
		
		for pointer in start_pointer..end_pointer
			@ram.at(pointer) = content.at(pointer)
		end
	end

end