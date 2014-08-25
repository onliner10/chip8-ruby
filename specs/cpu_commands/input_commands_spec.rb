require "./models/interpreter"
require "./models/stack"
require "./specs/helpers/interpreter_helper"

describe Interpreter, "input commands" do

	it "can do conditional skip based on input (EX9E - key NOT pressed)" do
	    memory = InterpreterTestHelper::memory_with_single_opcode("E19E")
	    keyboard_mock = InterpreterTestHelper::keyboard_mock

	    interpreter = Interpreter.new(memory, Stack.new, keyboard_mock)
	    interpreter.V1 = 3

	    interpreter.execute

	    expect(interpreter.PC).to eq("202".to_i(16))
	end

	it "can do conditional skip based on input (EX9E - key IS pressed)" do
	    memory = InterpreterTestHelper::memory_with_single_opcode("E19E")
	    keyboard_mock = InterpreterTestHelper::keyboard_mock
	    keyboard_mock.press(3)

	    interpreter = Interpreter.new(memory, Stack.new, keyboard_mock)
	    interpreter.V1 = 3

	    interpreter.execute

	    expect(interpreter.PC).to eq("204".to_i(16))
	end

	it "can do conditional skip based on input (EXA1  - key NOT pressed)" do
	    memory = InterpreterTestHelper::memory_with_single_opcode("E1A1")
	    keyboard_mock = InterpreterTestHelper::keyboard_mock

	    interpreter = Interpreter.new(memory, Stack.new, keyboard_mock)
	    interpreter.V1 = 3

	    interpreter.execute

	    expect(interpreter.PC).to eq("204".to_i(16))
	end

	it "can do conditional skip based on input (EXA1  - key IS pressed)" do
	    memory = InterpreterTestHelper::memory_with_single_opcode("E1A1")
	    keyboard_mock = InterpreterTestHelper::keyboard_mock
	    keyboard_mock.press(3)

	    interpreter = Interpreter.new(memory, Stack.new, keyboard_mock)
	    interpreter.V1 = 3

	    interpreter.execute

	    expect(interpreter.PC).to eq("202".to_i(16))
	end

	it "can wait for key press (FX0A  - key NOT pressed - should not change PC)" do
	    memory = InterpreterTestHelper::memory_with_single_opcode("F10A")
	    keyboard_mock = InterpreterTestHelper::keyboard_mock

	    interpreter = Interpreter.new(memory, Stack.new, keyboard_mock)
	    interpreter.execute

	    expect(interpreter.PC).to eq("200".to_i(16))
	end

	it "can wait for key press (FX0A  - key IS pressed - should change PC and store key in register)" do
	    memory = InterpreterTestHelper::memory_with_single_opcode("F10A")
	    keyboard_mock = InterpreterTestHelper::keyboard_mock
	    keyboard_mock.press("A".hex)

	    interpreter = Interpreter.new(memory, Stack.new, keyboard_mock)
	    interpreter.execute

	    expect(interpreter.PC).to eq("202".to_i(16))
	    expect(interpreter.V1).to eq("A".hex)
	end

end