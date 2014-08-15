class CPU

	def initialize(memory)
		@memory = memory
		define_registers

		self.PC = "200".hex
	end

	def do_cycle
	end

	private
	def define_registers
		@registers = {}

		private_registers = ["PC", "SP"]
		registers = Array.new + private_registers

		16.times { |n| registers.push((n+1).to_s(16).upcase) }
		registers.push("I")

		registers.each do |register_name|
			self.class.send(:define_method, "V#{register_name}") { @registers["V#{register_name}"] }
			self.class.send(:define_method, "V#{register_name}=(val)") { @registers["V#{register_name}"] = val }
		end

		private_registers.each do |privateRegister|
			self.class.instance_eval { private privateRegister.to_sym }
		end
	end

end