require './models/memory'

class VirtualMachine

	def initialize(memory)
		@memory = memory
	end

	def load_file_to_memory(path)
		binaryFile = File.binread(path)
		binaryContent = binaryFile.unpack("C*")

		@memory.load("200".hex, binaryContent)
	end

end