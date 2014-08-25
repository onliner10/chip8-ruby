require "./models/interpreter"
require "./models/stack"
require "./specs/helpers/interpreter_helper"

describe Interpreter, "stack commands" do

	it "can call subroutines (2NNN)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("2250")

    stack = Stack.new
    interpreter = Interpreter.new(memory, stack)
    interpreter.execute

    expect(stack.pop).to eq("202".to_i(16))
    expect(interpreter.PC).to eq("250".to_i(16))
  end

  it "can return from subroutines (00EE)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("00EE")
    stack = Stack.new
    stack.push("250".to_i(16))

    interpreter = Interpreter.new(memory, stack)
    interpreter.execute

    expect(interpreter.PC).to eq("250".to_i(16))
  end

end