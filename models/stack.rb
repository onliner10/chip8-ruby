class Stack
	def initialize 
		@stack = Array.new
	end

	def push(address)
		raise ArgumentError.new("Stack is full") unless @stack.size < 16

		@stack.push(address)
	end

	def pop
		@stack.pop
	end
end