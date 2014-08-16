require "./models/cpu"

describe CPU, "registry operation commands" do

  it "can do jump instruction (1NNN)" do
    memory = Memory.new

    memory.load("200".hex, "12".to_i(16))
    memory.load("201".hex, "30".to_i(16))

    cpu = CPU.new(memory)
    cpu.do_cycle

    expect(cpu.PC).to eq("230".to_i(16))
  end

  #The interpreter compares register Vx to kk, and if they are equal, increments the program counter by 2.
  it "can do conditional jump instruction (3XKK) (condition true)" do
    memory = Memory.new

    memory.load("200".hex, "3B".to_i(16))
    memory.load("201".hex, "89".to_i(16))

    cpu = CPU.new(memory)
    cpu.VB = "89".to_i(16)
    cpu.do_cycle

    expect(cpu.PC).to eq("204".to_i(16))
  end

  it "can do conditional jump instruction (3XKK) (condition false)" do
    memory = Memory.new

    memory.load("200".hex, "3B".to_i(16))
    memory.load("201".hex, "89".to_i(16))

    cpu = CPU.new(memory)
    cpu.VB = "15".to_i(16)
    cpu.do_cycle

    expect(cpu.PC).to eq("202".to_i(16))
  end

  #The interpreter compares register Vx to kk, and if they are NOT equal, increments the program counter by 2.
  it "can do conditional jump instruction (4XKK) (equal)" do
    memory = Memory.new

    memory.load("200".hex, "4C".to_i(16))
    memory.load("201".hex, "89".to_i(16))

    cpu = CPU.new(memory)
    cpu.VC = "89".to_i(16)
    cpu.do_cycle

    expect(cpu.PC).to eq("202".to_i(16))
  end

  it "can do conditional jump instruction (4XKK) (not equal)" do
    memory = Memory.new

    memory.load("200".hex, "4C".to_i(16))
    memory.load("201".hex, "89".to_i(16))

    cpu = CPU.new(memory)
    cpu.VC = "15".to_i(16)
    cpu.do_cycle

    expect(cpu.PC).to eq("204".to_i(16))
  end


  it "can set VX registers (6XKK)" do
  	memory = Memory.new

  	value_to_set = "58".to_i(16)
  	memory.load("200".hex, "65".to_i(16))
  	memory.load("201".hex, value_to_set)

    cpu = CPU.new(memory)
    cpu.do_cycle

    expect(cpu.V5).to eq(value_to_set)
  end

  it "can copy between registers (8XY0)" do
  	memory = Memory.new

  	#V2 = VA
  	memory.load("200".hex, "82".to_i(16))
  	memory.load("201".hex, "A0".to_i(16))

    cpu = CPU.new(memory)
    cpu.VA = 56

    cpu.do_cycle

    expect(cpu.V2).to eq(cpu.VA)
  end
end