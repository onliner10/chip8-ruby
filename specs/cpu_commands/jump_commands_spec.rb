require "./models/cpu"
require "./specs/helpers/cpu_helper"

describe CPU, "jump commands" do

	it "can do jump instruction (1NNN)" do
    memory = CpuTestHelper::memory_with_single_opcode("1230")

    cpu = CPU.new(memory)
    cpu.do_cycle

    expect(cpu.PC).to eq("230".to_i(16))
  end

  #The interpreter compares register Vx to kk, and if they are equal, increments the program counter by 2.
  it "can do conditional jump instruction (3XKK) (condition true)" do
    memory = CpuTestHelper::memory_with_single_opcode("3B89")

    cpu = CPU.new(memory)
    cpu.VB = "89".to_i(16)
    cpu.do_cycle

    expect(cpu.PC).to eq("204".to_i(16))
  end

  it "can do conditional jump instruction (3XKK) (condition false)" do
    memory = CpuTestHelper::memory_with_single_opcode("3B89")

    cpu = CPU.new(memory)
    cpu.VB = "15".to_i(16)
    cpu.do_cycle

    expect(cpu.PC).to eq("202".to_i(16))
  end

  #The interpreter compares register Vx to kk, and if they are NOT equal, increments the program counter by 2.
  it "can do conditional jump instruction (4XKK) (equal)" do
    memory = CpuTestHelper::memory_with_single_opcode("4C89")

    cpu = CPU.new(memory)
    cpu.VC = "89".to_i(16)
    cpu.do_cycle

    expect(cpu.PC).to eq("202".to_i(16))
  end

  it "can do conditional jump instruction (4XKK) (not equal)" do
    memory = CpuTestHelper::memory_with_single_opcode("4C89")

    cpu = CPU.new(memory)
    cpu.VC = "15".to_i(16)
    cpu.do_cycle

    expect(cpu.PC).to eq("204".to_i(16))
  end

  it "can do conditional jump instruction (5XY0) (equal)" do
    memory = CpuTestHelper::memory_with_single_opcode("5EF0")

    cpu = CPU.new(memory)
    cpu.VE = 1
    cpu.VF = 1
    cpu.do_cycle

    expect(cpu.PC).to eq("204".to_i(16))
  end

  it "can do conditional jump instruction (5XY0) (not equal)" do
    memory = CpuTestHelper::memory_with_single_opcode("5280")

    cpu = CPU.new(memory)
    cpu.V2 = 1
    cpu.V8 = 2
    cpu.do_cycle

    expect(cpu.PC).to eq("202".to_i(16))
  end
	
  it "can do jump with adding V0 to specified value (BNNN)" do
    memory = CpuTestHelper::memory_with_single_opcode("B200")

    cpu = CPU.new(memory)
    cpu.V0 = "20".to_i(16)
    cpu.do_cycle

    expect(cpu.PC).to eq("220".to_i(16))
  end

    it "can skip if Vx != Vy (9XY0) (not equal - skip condition true)" do
    memory = CpuTestHelper::memory_with_single_opcode("9120")

    cpu = CPU.new(memory)
    cpu.V1 = 1
    cpu.V2 = 2

    cpu.do_cycle

    expect(cpu.PC).to eq("204".to_i(16))
  end

  it "can skip if Vx != Vy (9XY0) (equal - skip condition false)" do
    memory = CpuTestHelper::memory_with_single_opcode("9120")

    cpu = CPU.new(memory)
    cpu.V1 = 2
    cpu.V2 = 2

    cpu.do_cycle

    expect(cpu.PC).to eq("202".to_i(16))
  end
end