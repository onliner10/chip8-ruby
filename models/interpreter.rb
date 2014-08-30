Dir[File.dirname(__FILE__) + "/interpreter_commands/*.rb"].each { |f| require f }
require "./models/keyboard"
require "./models/stack"
require "./models/memory"
require "./models/timer"
require "./models/win_beeper"

class Interpreter
	def initialize(
		memory = Memory.new,
		stack = Stack.new, 
		keyboard = Keyboard.new, 
		display = Display.new, 
		beeper = WinBeeper.new)

		@memory = memory
		@stack = stack
		@keyboard = keyboard
		@display = display
		@beeper = beeper

		define_registers

		self.PC = "200".hex
	end

	def execute
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

		raise ArgumentError.new("More than one (or none) command found for opcode #{name} (found commands: #{matchingMethods})") unless matchingMethods.one?

		matchingMethod = matchingMethods.first
		helper = Class.new

		variables = matchingMethod.to_s.scan(/([G-Z])/).uniq.map { |x| x.first}

		variables.map do |variable|
			variableValue = matchingMethod.to_s.gsub('opcode_','').split('').
																   map.with_index(0).
																   select { |c,i| c == variable}.
																   map {|c,i| name[i]}.join
			

			helper.instance_exec(self) do |interpreter|
				define_singleton_method("var_#{variable}") do
					variableValue.to_i(16)
				end

				if(variableValue.between?('0', 'F'))
					define_singleton_method("registry_#{variable}") do 
						interpreter.send("V#{variableValue}")
					end

					define_singleton_method("registry_#{variable}=") do |v|
						interpreter.send("V#{variableValue}=", v)
					end
				end
			end
		end

		send(matchingMethod, helper)
	end

	def DT
		@delay_timer ||= Timer.new
	end

	def ST
		if(@sound_timer == nil)
			@sound_timer = Timer.new
			@sound_timer.when_activated { @beeper.start }
			@sound_timer.when_complete { @beeper.end }
		end

		@sound_timer
	end

	private
	def define_registers
		@registers = {}

		registers_and_their_size = [["PC", 16], ["I", 16]]

		#registers V0 to VF
		0.upto(15) { |n| registers_and_their_size.push(["V" + n.to_s(16).upcase, 8]) }

		registers_and_their_size.each do |name, size|
			self.class.send(:define_method, "#{name}") { @registers["#{name}"] }

			self.class.send(:define_method, "#{name}=") do |v| 
				mask = 0
				size.times { |i| mask += 1 << i }

				@registers["#{name}"] = v & mask
			end
		end
	end
end