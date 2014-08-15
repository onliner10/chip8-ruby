require "./models/cpu"

describe CPU, "do_cycle" do
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
    cpu.do_cycle

    expect(cpu.V2).to eq(cpu.VA)
  end
end