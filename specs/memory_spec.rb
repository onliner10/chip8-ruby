require "./models/memory"

describe Memory, "#load" do
  it "loads data to memory" do
    memory = Memory.new

    data_to_load = Array.new(230)
    data_to_load.each { |e| e = 166 }

    memory.load("200".hex, data_to_load)

  end
end

describe Memory, "" do
  it "gives instruction at specified address" do
    memory = Memory.new
    memory.load("200".hex, "65".to_i(16))
  	memory.load("201".hex, "55".to_i(16))

  	instruction = memory.instruction_at("200".hex)

    expect(instruction).to eq("6555")
  end

  it "gives byte at specified address" do
    memory = Memory.new
    memory.load("200".hex, 100)

    byte = memory.byte_at("200".hex)

    expect(byte).to eq(100)
  end

  it "can give range" do
    memory = Memory.new
    memory.load("200".hex, 100)
    memory.load("201".hex, 120)
    memory.load("202".hex, 130)
    memory.load("203".hex, 140)

    range = memory.range("200".hex, "203".hex)

    expect(range[0]).to eq(100)
    expect(range[1]).to eq(120)
    expect(range[2]).to eq(130)
    expect(range[3]).to eq(140)
  end

  it "can give range in bits" do
    memory = Memory.new
    memory.load("200".hex, 137)

    range = memory.range_bits("200".hex, "200".hex)

    expect(range.size).to eq(8)
    expect(range).to eq([1,0,0,0,1,0,0,1])
  end

  it "gives 4 letter instruction at specified address when zero is the two LAST characters of opcode" do
    memory = Memory.new
    memory.load("200".hex, "65".to_i(16))
    memory.load("201".hex, "00".to_i(16))

    instruction = memory.instruction_at("200".hex)

    expect(instruction).to eq("6500")
  end

  it "gives 4 letter instruction at specified address when zero is the two FIRST characters of opcode" do
    memory = Memory.new
    memory.load("200".hex, "00".to_i(16))
    memory.load("201".hex, "EE".to_i(16))

    instruction = memory.instruction_at("200".hex)

    expect(instruction).to eq("00EE")
  end
end
