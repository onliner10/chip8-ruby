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

		foundCommands = self.class.instance_methods(false).grep(/opcode_.*/)

		matchingCommands = foundCommands.select do |command| 
			regex = Regexp.new command.to_s.gsub('opcode_', '').gsub(/[G-Z]/, '[0-9A-F]')
			opcode.upcase =~ regex
		end

		raise "More than one (or none) command found for opcode #{opcode} (found commands: #{matchingCommands}" unless matchingCommands.one?

		matchingCommand = matchingCommands.first
		commandVariables = matchingCommand.to_s.scan(/([G-Z])/).uniq.map { |x| x.first}

		commandVariables.map do |variable|
			variableValue = matchingCommand.to_s.gsub('opcode_','').split('').
											map.with_index(0).
											select { |c,i| c == variable}.
											map {|c,i| opcode[i]}.join

			self.class.send(:define_method, "var_#{variable}") { variableValue.to_i(16) }

			if(variableValue.between?('0', 'F'))
				self.class.send(:define_method, "registry_#{variable}") do 
					send("V#{variableValue}") 
				end

				self.class.send(:define_method, "registry_#{variable}=") do |v|
					send("V#{variableValue}=", v) 
				end
			end
		end

		send(matchingCommand, opcode)

		self.methods.grep(/((var|registry)_.*)/).each do |helper|
			self.class.send(:remove_method, "#{helper}")
		end
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