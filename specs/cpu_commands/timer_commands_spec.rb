require "./models/interpreter"
require "./models/stack"
require "./models/display"
require "./specs/helpers/interpreter_helper"

describe Interpreter, "timer commands" do

	it "place DT Timer value into register (Fx07 )" do
		memory = InterpreterTestHelper::memory_with_single_opcode("F207")
		interpreter = Interpreter.new(memory)

		interpreter.execute

		expect(interpreter.V2).to eq(0)
	end

	it "can set Delay Timer (Fx15)" do
		memory = InterpreterTestHelper::memory_with_single_opcode("F215")
		interpreter = Interpreter.new(memory)
		interpreter.V2 = 100

		interpreter.execute

		expect(interpreter.DT.value).to eq(100)
	end

	it "can set Sound Timer (Fx18)" do
		memory = InterpreterTestHelper::memory_with_single_opcode("F218")

		mocked_beeper = Class.new do
			class << self
				def start
				end

				def stop
				end
			end
		end

		interpreter = Interpreter.new(memory,nil,nil,nil,mocked_beeper)
		interpreter.V2 = 15

		expect(mocked_beeper).to receive(:start)
		interpreter.execute

		expect(interpreter.ST.value).to eq(15)
	end

end