class Timer

	def initialize
		@value = 0
		@when_complete = Proc.new { }
		@when_activated = Proc.new { }
	end

	def set(val)
		raise ArgumentError.new("Timer value cannot be less than zero!") if(val < 0)
		@when_activated.call

		@value = val
		run_counter_thread
	end

	def value
		@value
	end

	def when_complete(&block)
		@when_complete = block
	end

	def when_activated(&block)
		@when_activated = block
	end

	private
	def run_counter_thread
		timer = Thread.new do 
			while(true) do
				#60Hz
				sleep(1.0 / 60.0)

				if(@value <= 0)
					@when_complete.call
					Thread.current.kill 
				end
				@value -= 1 
			end
		end
	end
end