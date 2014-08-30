require "./models/interpreter"
require "./models/stack"
require "./models/display"
require "./specs/helpers/interpreter_helper"

describe Interpreter, "display commands" do

	it "can display sprites (DXYN)" do
		memory = InterpreterTestHelper::memory_with_single_opcode("D121")
		memory.load("250".hex, 255)

		display = Display.new

		interpreter = Interpreter.new(memory, nil, nil, display)
		interpreter.I = "250".hex
		interpreter.V1 = 0
		interpreter.V2 = 0

		interpreter.execute
		screen = display.buffer
		
		8.times { |i| expect(screen[0][i]).to eq(1) }
		expect(screen[0][8]).to eq(0)
	end

	it "can clear the screen (00E0)" do
		memory = InterpreterTestHelper::memory_with_single_opcode("00E0")
		display = Display.new

		interpreter = Interpreter.new(memory, nil, nil, display)

		expect(display).to receive(:clear)
		interpreter.execute
	end

end