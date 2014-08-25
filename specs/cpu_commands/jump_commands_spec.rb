require "./models/interpreter"
require "./specs/helpers/interpreter_helper"

describe Interpreter, "jump commands" do

	it "can do jump instruction (1NNN)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("1230")

    interpreter = Interpreter.new(memory)
    interpreter.execute

    expect(interpreter.PC).to eq("230".to_i(16))
  end

  #The interpreter compares register Vx to kk, and if they are equal, increments the program counter by 2.
  it "can do conditional jump instruction (3XKK) (condition true)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("3B89")

    interpreter = Interpreter.new(memory)
    interpreter.VB = "89".to_i(16)
    interpreter.execute

    expect(interpreter.PC).to eq("204".to_i(16))
  end

  it "can do conditional jump instruction (3XKK) (condition false)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("3B89")

    interpreter = Interpreter.new(memory)
    interpreter.VB = "15".to_i(16)
    interpreter.execute

    expect(interpreter.PC).to eq("202".to_i(16))
  end

  #The interpreter compares register Vx to kk, and if they are NOT equal, increments the program counter by 2.
  it "can do conditional jump instruction (4XKK) (equal)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("4C89")

    interpreter = Interpreter.new(memory)
    interpreter.VC = "89".to_i(16)
    interpreter.execute

    expect(interpreter.PC).to eq("202".to_i(16))
  end

  it "can do conditional jump instruction (4XKK) (not equal)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("4C89")

    interpreter = Interpreter.new(memory)
    interpreter.VC = "15".to_i(16)
    interpreter.execute

    expect(interpreter.PC).to eq("204".to_i(16))
  end

  it "can do conditional jump instruction (5XY0) (equal)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("5EF0")

    interpreter = Interpreter.new(memory)
    interpreter.VE = 1
    interpreter.VF = 1
    interpreter.execute

    expect(interpreter.PC).to eq("204".to_i(16))
  end

  it "can do conditional jump instruction (5XY0) (not equal)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("5280")

    interpreter = Interpreter.new(memory)
    interpreter.V2 = 1
    interpreter.V8 = 2
    interpreter.execute

    expect(interpreter.PC).to eq("202".to_i(16))
  end
	
  it "can do jump with adding V0 to specified value (BNNN)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("B200")

    interpreter = Interpreter.new(memory)
    interpreter.V0 = "20".to_i(16)
    interpreter.execute

    expect(interpreter.PC).to eq("220".to_i(16))
  end

    it "can skip if Vx != Vy (9XY0) (not equal - skip condition true)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("9120")

    interpreter = Interpreter.new(memory)
    interpreter.V1 = 1
    interpreter.V2 = 2

    interpreter.execute

    expect(interpreter.PC).to eq("204".to_i(16))
  end

  it "can skip if Vx != Vy (9XY0) (equal - skip condition false)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("9120")

    interpreter = Interpreter.new(memory)
    interpreter.V1 = 2
    interpreter.V2 = 2

    interpreter.execute

    expect(interpreter.PC).to eq("202".to_i(16))
  end
end