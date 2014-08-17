require "./models/cpu"

def memory_with_single_opcode(opcode)
    memory = Memory.new

    memory.load("200".hex, opcode[0..1].to_i(16))
    memory.load("201".hex, opcode[2..3].to_i(16))

    memory
  end

describe CPU, "registry operation commands" do

  it "can do jump instruction (1NNN)" do
    memory = memory_with_single_opcode("1230")

    cpu = CPU.new(memory)
    cpu.do_cycle

    expect(cpu.PC).to eq("230".to_i(16))
  end

  #The interpreter compares register Vx to kk, and if they are equal, increments the program counter by 2.
  it "can do conditional jump instruction (3XKK) (condition true)" do
    memory = memory_with_single_opcode("3B89")

    cpu = CPU.new(memory)
    cpu.VB = "89".to_i(16)
    cpu.do_cycle

    expect(cpu.PC).to eq("204".to_i(16))
  end

  it "can do conditional jump instruction (3XKK) (condition false)" do
    memory = memory_with_single_opcode("3B89")

    cpu = CPU.new(memory)
    cpu.VB = "15".to_i(16)
    cpu.do_cycle

    expect(cpu.PC).to eq("202".to_i(16))
  end

  #The interpreter compares register Vx to kk, and if they are NOT equal, increments the program counter by 2.
  it "can do conditional jump instruction (4XKK) (equal)" do
    memory = memory_with_single_opcode("4C89")

    cpu = CPU.new(memory)
    cpu.VC = "89".to_i(16)
    cpu.do_cycle

    expect(cpu.PC).to eq("202".to_i(16))
  end

  it "can do conditional jump instruction (4XKK) (not equal)" do
    memory = memory_with_single_opcode("4C89")

    cpu = CPU.new(memory)
    cpu.VC = "15".to_i(16)
    cpu.do_cycle

    expect(cpu.PC).to eq("204".to_i(16))
  end

  it "can do conditional jump instruction (5XY0) (equal)" do
    memory = memory_with_single_opcode("5EF0")

    cpu = CPU.new(memory)
    cpu.VE = 1
    cpu.VF = 1
    cpu.do_cycle

    expect(cpu.PC).to eq("204".to_i(16))
  end

  it "can do conditional jump instruction (5XY0) (not equal)" do
    memory = memory_with_single_opcode("5280")

    cpu = CPU.new(memory)
    cpu.V2 = 1
    cpu.V8 = 2
    cpu.do_cycle

    expect(cpu.PC).to eq("202".to_i(16))
  end

  it "can set VX registers (6XKK)" do
  	memory = memory_with_single_opcode("6558")

    cpu = CPU.new(memory)
    cpu.do_cycle

    expect(cpu.V5).to eq("58".to_i(16))
  end

  it "can increment registry by specified value (7XKK)" do
    memory = memory_with_single_opcode("7B32")

    cpu = CPU.new(memory)
    cpu.VB = "20".to_i(16)
    expected = "20".to_i(16) + "32".to_i(16)

    cpu.do_cycle

    expect(cpu.VB).to eq(expected)
  end

  it "can copy between registers (8XY0)" do
  	#V2 = VA
    memory = memory_with_single_opcode("82A0")

    cpu = CPU.new(memory)
    cpu.VA = 56

    cpu.do_cycle

    expect(cpu.V2).to eq(cpu.VA)
  end

  it "can do bitwise OR on registers (8XY1)" do
    #V3 = V3 OR V4
    memory = memory_with_single_opcode("8341")

    cpu = CPU.new(memory)
    cpu.V3 = 56
    cpu.V4 = 88

    cpu.do_cycle

    expect(cpu.V3).to eq(120)
  end

  it "can do bitwise AND on registers (8XY2)" do
    #V7 = V7 AND V1
    memory = memory_with_single_opcode("8712")

    cpu = CPU.new(memory)
    cpu.V7 = 20
    cpu.V1 = 30

    cpu.do_cycle

    expect(cpu.V7).to eq(20)
  end

  it "can do bitwise XOR on registers (8XY3)" do
    #V4 = V4 XOR VA
    memory = memory_with_single_opcode("84A3")

    cpu = CPU.new(memory)
    cpu.V4 = 27
    cpu.VA = 28

    cpu.do_cycle

    expect(cpu.V4).to eq(7)
  end

  it "can add registers each other (8XY4) (without overflowing 8-bits)" do
    #V1 = V1 + V2
    memory = memory_with_single_opcode("8124")

    cpu = CPU.new(memory)
    cpu.V1 = 20
    cpu.V2 = 30

    cpu.do_cycle

    expect(cpu.V1).to eq(50)
    expect(cpu.VF).to eq(0)
  end

  it "can add registers each other (8XY4) (with overflowing 8-bits)" do
    #V1 = V1 + V2
    memory = memory_with_single_opcode("8124")

    cpu = CPU.new(memory)
    cpu.V1 = 200
    cpu.V2 = 56

    cpu.do_cycle

    expect(cpu.V1).to eq(1)
    expect(cpu.VF).to eq(1)
  end

  it "can substract registers each other (8XY5) (Vx > Vy)" do
    #V1 = V1 - V2
    memory = memory_with_single_opcode("8125")

    cpu = CPU.new(memory)
    cpu.V1 = 200
    cpu.V2 = 70

    cpu.do_cycle

    expect(cpu.V1).to eq(130)
    expect(cpu.VF).to eq(1)
  end

  it "can substract registers each other (8XY5) (Vx < Vy)" do
    #V1 = V1 - V2
    memory = memory_with_single_opcode("8125")

    cpu = CPU.new(memory)
    cpu.V1 = 70
    cpu.V2 = 200

    cpu.do_cycle

    expect(cpu.V1).to eq(130)
    expect(cpu.VF).to eq(0)
  end

end