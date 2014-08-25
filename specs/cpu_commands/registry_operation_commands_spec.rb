require "./models/interpreter"
require "./specs/helpers/interpreter_helper"

describe Interpreter, "registry operation commands" do

  it "can set VX registers (6XKK)" do
  	memory = InterpreterTestHelper::memory_with_single_opcode("6558")

    interpreter = Interpreter.new(memory)
    interpreter.execute

    expect(interpreter.V5).to eq("58".to_i(16))
  end

  it "can increment registry by specified value (7XKK)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("7B32")

    interpreter = Interpreter.new(memory)
    interpreter.VB = "20".to_i(16)
    expected = "20".to_i(16) + "32".to_i(16)

    interpreter.execute

    expect(interpreter.VB).to eq(expected)
  end

  it "can copy between registers (8XY0)" do
  	#V2 = VA
    memory = InterpreterTestHelper::memory_with_single_opcode("82A0")

    interpreter = Interpreter.new(memory)
    interpreter.VA = 56

    interpreter.execute

    expect(interpreter.V2).to eq(interpreter.VA)
  end

  it "can do bitwise OR on registers (8XY1)" do
    #V3 = V3 OR V4
    memory = InterpreterTestHelper::memory_with_single_opcode("8341")

    interpreter = Interpreter.new(memory)
    interpreter.V3 = 56
    interpreter.V4 = 88

    interpreter.execute

    expect(interpreter.V3).to eq(120)
  end

  it "can do bitwise AND on registers (8XY2)" do
    #V7 = V7 AND V1
    memory = InterpreterTestHelper::memory_with_single_opcode("8712")

    interpreter = Interpreter.new(memory)
    interpreter.V7 = 20
    interpreter.V1 = 30

    interpreter.execute

    expect(interpreter.V7).to eq(20)
  end

  it "can do bitwise XOR on registers (8XY3)" do
    #V4 = V4 XOR VA
    memory = InterpreterTestHelper::memory_with_single_opcode("84A3")

    interpreter = Interpreter.new(memory)
    interpreter.V4 = 27
    interpreter.VA = 28

    interpreter.execute

    expect(interpreter.V4).to eq(7)
  end

  it "can add registers each other (8XY4) (without overflowing 8-bits)" do
    #V1 = V1 + V2
    memory = InterpreterTestHelper::memory_with_single_opcode("8124")

    interpreter = Interpreter.new(memory)
    interpreter.V1 = 20
    interpreter.V2 = 30

    interpreter.execute

    expect(interpreter.V1).to eq(50)
    expect(interpreter.VF).to eq(0)
  end

  it "can add registers each other (8XY4) (with overflowing 8-bits)" do
    #V1 = V1 + V2
    memory = InterpreterTestHelper::memory_with_single_opcode("8124")

    interpreter = Interpreter.new(memory)
    interpreter.V1 = 200
    interpreter.V2 = 56

    interpreter.execute

    expect(interpreter.V1).to eq(0)
    expect(interpreter.VF).to eq(1)
  end

  it "can substract registers each other (8XY5) (Vx > Vy)" do
    #V1 = V1 - V2
    memory = InterpreterTestHelper::memory_with_single_opcode("8125")

    interpreter = Interpreter.new(memory)
    interpreter.V1 = 200
    interpreter.V2 = 70

    interpreter.execute

    expect(interpreter.V1).to eq(130)
    expect(interpreter.VF).to eq(1)
  end

  it "can substract registers each other (8XY5) (Vx < Vy)" do
    #V1 = V1 - V2
    memory = InterpreterTestHelper::memory_with_single_opcode("8125")

    interpreter = Interpreter.new(memory)
    interpreter.V1 = 70
    interpreter.V2 = 200

    interpreter.execute

    expect(interpreter.V1).to eq(130)
    expect(interpreter.VF).to eq(0)
  end

  it "can do bitwise shift (8XY6) (least significant bit is one)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("8126")

    interpreter = Interpreter.new(memory)
    interpreter.V1 = 11

    interpreter.execute

    expect(interpreter.VF).to eq(1)
    expect(interpreter.V1).to eq(5)
  end

  it "can do bitwise shift (8XY6) (least significant bit is zero)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("8126")

    interpreter = Interpreter.new(memory)
    interpreter.V1 = 10

    interpreter.execute

    expect(interpreter.VF).to eq(0)
    expect(interpreter.V1).to eq(5)
  end

  it "can substract (8XY7) (Vy > Vx)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("8127")

    interpreter = Interpreter.new(memory)
    interpreter.V1 = 10
    interpreter.V2 = 30

    interpreter.execute

    expect(interpreter.VF).to eq(1)
    expect(interpreter.V1).to eq(20)
  end

  it "can substract (8XY7) (Vy <= Vx)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("8127")

    interpreter = Interpreter.new(memory)
    interpreter.V1 = 80
    interpreter.V2 = 30

    interpreter.execute

    expect(interpreter.VF).to eq(0)
    expect(interpreter.V1).to eq(50)
  end

  it "can multiply (8XYE) (most significant byte is one)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("812E")

    interpreter = Interpreter.new(memory)
    interpreter.V1 = 200
    interpreter.V2 = 2

    interpreter.execute

    expect(interpreter.VF).to eq(1)
    expect(interpreter.V1).to eq(144)
  end

  it "can multiply (8XYE) (most significant byte is zero)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("812E")

    interpreter = Interpreter.new(memory)
    interpreter.V1 = 11
    interpreter.V2 = 2

    interpreter.execute

    expect(interpreter.VF).to eq(0)
    expect(interpreter.V1).to eq(22)
  end

  it "can set I registry value (ANNN)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("A111")

    interpreter = Interpreter.new(memory)
    interpreter.execute

    expect(interpreter.I).to eq("111".to_i(16))
  end

  it "can generate random values (CXKK)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("C012")

    interpreter = Interpreter.new(memory)
    interpreter.execute

    expect(interpreter.V0).not_to be_nil
  end

  it "can store BCD representation (FX33)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("F133")

    interpreter = Interpreter.new(memory)
    interpreter.I = "250".hex
    interpreter.V1 = 123
    interpreter.execute

    expect(memory.byte_at("250".hex)).to eq(1)
    expect(memory.byte_at("251".hex)).to eq(2)
    expect(memory.byte_at("252".hex)).to eq(3)
  end

end