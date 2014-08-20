require "./models/cpu_commands/registry_operation_commands"
require "pry"

class CPU

	def initialize(memory)
		@memory = memory
		define_registers

		self.PC = "200".hex
	end

	def do_cycle
		opcode = @memory.instruction_at(self.PC)
		self.PC += 2

		self.send(opcode)
	end

	def method_missing(name)
		raise NoMethodError.new("Method #{name} not found") unless name =~ /^[0-9a-fA-F]+$/

		foundCommands = self.class.instance_methods(false).grep(/opcode_.*/)

		matchingMethods = foundCommands.select do |command| 
			regex = Regexp.new command.to_s.gsub('opcode_', '').gsub(/[G-Z]/, '[0-9A-F]')
			name.upcase =~ regex
		end

		raise "More than one (or none) command found for opcode #{name} (found commands: #{matchingCommands})" unless matchingMethods.one?

		matchingMethod = matchingMethods.first
		helper = Class.new

		variables = matchingMethod.to_s.scan(/([G-Z])/).uniq.map { |x| x.first}
		variables.map do |variable|
			variableValue = matchingMethod.to_s.gsub('opcode_','').split('').
											map.with_index(0).
											select { |c,i| c == variable}.
											map {|c,i| name[i]}.join
			
			helper.instance_exec(self) do |cpu|
				self.class.send(:define_method,"var_#{variable}") do
					variableValue.to_i(16)
				end

				if(variableValue.between?('0', 'F'))
					self.class.send(:define_method, "registry_#{variable}") do 
						cpu.send("V#{variableValue}")
					end

					self.class.send(:define_method, "registry_#{variable}=") do |v|
						cpu.send("V#{variableValue}=", v)
					end
				end
			end
		end

		send(matchingMethod, helper)
	end

	private
	def define_registers
		@registers = {}

		registers = ["PC", "SP", "I"]

		#registers V1 to VF
		1.upto(15) { |n| registers.push("V" + n.to_s(16).upcase) }

		registers.each do |register_name|
			self.class.send(:define_method, "#{register_name}") { @registers["#{register_name}"] }
			self.class.send(:define_method, "#{register_name}=") { |v| @registers["#{register_name}"] = v }
		end
	end
end