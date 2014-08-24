require './models/memory'
require './models/display'


class VirtualMachine

	def initialize(memory)
		@memory = memory
		@memory.load(0, Display.sprites)
	end

	def load_file_to_memory(path, address = 512)
		binaryFile = File.binread(path)
		binaryContent = binaryFile.unpack("C*")

		@memory.load(address, binaryContent)
	end

end