require "./models/cpu"
require "./specs/helpers/cpu_helper"

describe CPU, "registry operation commands" do

  it "can set VX registers (6XKK)" do
  	memory = CpuTestHelper::memory_with_single_opcode("6558")

    cpu = CPU.new(memory)
    cpu.do_cycle

    expect(cpu.V5).to eq("58".to_i(16))
  end

  it "can increment registry by specified value (7XKK)" do
    memory = CpuTestHelper::memory_with_single_opcode("7B32")

    cpu = CPU.new(memory)
    cpu.VB = "20".to_i(16)
    expected = "20".to_i(16) + "32".to_i(16)

    cpu.do_cycle

    expect(cpu.VB).to eq(expected)
  end

  it "can copy between registers (8XY0)" do
  	#V2 = VA
    memory = CpuTestHelper::memory_with_single_opcode("82A0")

    cpu = CPU.new(memory)
    cpu.VA = 56

    cpu.do_cycle

    expect(cpu.V2).to eq(cpu.VA)
  end

  it "can do bitwise OR on registers (8XY1)" do
    #V3 = V3 OR V4
    memory = CpuTestHelper::memory_with_single_opcode("8341")

    cpu = CPU.new(memory)
    cpu.V3 = 56
    cpu.V4 = 88

    cpu.do_cycle

    expect(cpu.V3).to eq(120)
  end

  it "can do bitwise AND on registers (8XY2)" do
    #V7 = V7 AND V1
    memory = CpuTestHelper::memory_with_single_opcode("8712")

    cpu = CPU.new(memory)
    cpu.V7 = 20
    cpu.V1 = 30

    cpu.do_cycle

    expect(cpu.V7).to eq(20)
  end

  it "can do bitwise XOR on registers (8XY3)" do
    #V4 = V4 XOR VA
    memory = CpuTestHelper::memory_with_single_opcode("84A3")

    cpu = CPU.new(memory)
    cpu.V4 = 27
    cpu.VA = 28

    cpu.do_cycle

    expect(cpu.V4).to eq(7)
  end

  it "can add registers each other (8XY4) (without overflowing 8-bits)" do
    #V1 = V1 + V2
    memory = CpuTestHelper::memory_with_single_opcode("8124")

    cpu = CPU.new(memory)
    cpu.V1 = 20
    cpu.V2 = 30

    cpu.do_cycle

    expect(cpu.V1).to eq(50)
    expect(cpu.VF).to eq(0)
  end

  it "can add registers each other (8XY4) (with overflowing 8-bits)" do
    #V1 = V1 + V2
    memory = CpuTestHelper::memory_with_single_opcode("8124")

    cpu = CPU.new(memory)
    cpu.V1 = 200
    cpu.V2 = 56

    cpu.do_cycle

    expect(cpu.V1).to eq(0)
    expect(cpu.VF).to eq(1)
  end

  it "can substract registers each other (8XY5) (Vx > Vy)" do
    #V1 = V1 - V2
    memory = CpuTestHelper::memory_with_single_opcode("8125")

    cpu = CPU.new(memory)
    cpu.V1 = 200
    cpu.V2 = 70

    cpu.do_cycle

    expect(cpu.V1).to eq(130)
    expect(cpu.VF).to eq(1)
  end

  it "can substract registers each other (8XY5) (Vx < Vy)" do
    #V1 = V1 - V2
    memory = CpuTestHelper::memory_with_single_opcode("8125")

    cpu = CPU.new(memory)
    cpu.V1 = 70
    cpu.V2 = 200

    cpu.do_cycle

    expect(cpu.V1).to eq(130)
    expect(cpu.VF).to eq(0)
  end

  it "can do bitwise shift (8XY6) (least significant bit is one)" do
    memory = CpuTestHelper::memory_with_single_opcode("8126")

    cpu = CPU.new(memory)
    cpu.V1 = 11

    cpu.do_cycle

    expect(cpu.VF).to eq(1)
    expect(cpu.V1).to eq(5)
  end

  it "can do bitwise shift (8XY6) (least significant bit is zero)" do
    memory = CpuTestHelper::memory_with_single_opcode("8126")

    cpu = CPU.new(memory)
    cpu.V1 = 10

    cpu.do_cycle

    expect(cpu.VF).to eq(0)
    expect(cpu.V1).to eq(5)
  end

  it "can substract (8XY7) (Vy > Vx)" do
    memory = CpuTestHelper::memory_with_single_opcode("8127")

    cpu = CPU.new(memory)
    cpu.V1 = 10
    cpu.V2 = 30

    cpu.do_cycle

    expect(cpu.VF).to eq(1)
    expect(cpu.V1).to eq(20)
  end

  it "can substract (8XY7) (Vy <= Vx)" do
    memory = CpuTestHelper::memory_with_single_opcode("8127")

    cpu = CPU.new(memory)
    cpu.V1 = 80
    cpu.V2 = 30

    cpu.do_cycle

    expect(cpu.VF).to eq(0)
    expect(cpu.V1).to eq(50)
  end

  it "can multiply (8XYE) (most significant byte is one)" do
    memory = CpuTestHelper::memory_with_single_opcode("812E")

    cpu = CPU.new(memory)
    cpu.V1 = 200
    cpu.V2 = 2

    cpu.do_cycle

    expect(cpu.VF).to eq(1)
    expect(cpu.V1).to eq(144)
  end

  it "can multiply (8XYE) (most significant byte is zero)" do
    memory = CpuTestHelper::memory_with_single_opcode("812E")

    cpu = CPU.new(memory)
    cpu.V1 = 11
    cpu.V2 = 2

    cpu.do_cycle

    expect(cpu.VF).to eq(0)
    expect(cpu.V1).to eq(22)
  end

  it "can set I registry value (ANNN)" do
    memory = CpuTestHelper::memory_with_single_opcode("A111")

    cpu = CPU.new(memory)
    cpu.do_cycle

    expect(cpu.I).to eq("111".to_i(16))
  end

  it "can generate random values (CXKK)" do
    memory = CpuTestHelper::memory_with_single_opcode("C012")

    cpu = CPU.new(memory)
    cpu.do_cycle

    expect(cpu.V0).not_to be_nil
  end

  it "can store BCD representation (FX33)" do
    memory = CpuTestHelper::memory_with_single_opcode("F133")

    cpu = CPU.new(memory)
    cpu.I = "250".hex
    cpu.V1 = 123
    cpu.do_cycle

    expect(memory.byte_at("250".hex)).to eq(1)
    expect(memory.byte_at("251".hex)).to eq(2)
    expect(memory.byte_at("252".hex)).to eq(3)
  end

end