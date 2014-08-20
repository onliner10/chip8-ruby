require "./models/memory"

describe Memory, "#load" do
  it "loads data to memory" do
    memory = Memory.new

    data_to_load = Array.new(230)
    data_to_load.each { |e| e = 166 }

    memory.load("200".hex, data_to_load)

  end
end

describe Memory, "#instruction_at" do
  it "gives instruction at specified address" do
    memory = Memory.new
    memory.load("200".hex, "65".to_i(16))
  	memory.load("201".hex, "55".to_i(16))

  	instruction = memory.instruction_at("200".hex)

    expect(instruction).to eq("6555")
  end

  it "gives 4 letter instruction at specified address when zero is the two last characters of opcode" do
    memory = Memory.new
    memory.load("200".hex, "65".to_i(16))
    memory.load("201".hex, "00".to_i(16))

    instruction = memory.instruction_at("200".hex)

    expect(instruction).to eq("6500")
  end
end
