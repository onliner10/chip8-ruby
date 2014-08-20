require "./models/stack"

describe Stack, "" do

	it "can push and retrieve addresses" do
	    stack = Stack.new
	    stack.push(100)

    	expect(stack.pop).to eq(100)
  	end

  	it "throws error when overflow" do
  		stack = Stack.new

  		expect {
  			17.times { stack.push(12) }
  		}.to raise_error(ArgumentError)
  	end

  	it "removes poped things from stack" do
  		stack = Stack.new
  		16.times { stack.push(12) }
  		
  		stack.pop
  		stack.push(44)

  		expect(stack.pop).to eq(44)
  	end

end