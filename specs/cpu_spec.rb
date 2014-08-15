require "./models/cpu"

describe CPU, "do_cycle" do
  it "can set VX registers" do
  	memory = Memory.new

  	value_to_set = "58".to_i(16)
  	memory.load("200".hex, "65".to_i(16))
  	memory.load("201".hex, value_to_set)

    cpu = CPU.new(memory)
    cpu.do_cycle

    expect(cpu.V5).to eq(value_to_set)
  end
end