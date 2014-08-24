require './models/memory'

class VirtualMachine

	def initialize(memory)
		@memory = memory

		load_file_to_memory("./models/assets/sprites.hex", 0)
	end

	def load_file_to_memory(path, address = 512)
		binaryFile = File.binread(path)
		binaryContent = binaryFile.unpack("C*")

		@memory.load(address, binaryContent)
	end

end