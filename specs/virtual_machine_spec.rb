require "./models/virtual_machine"

describe VirtualMachine, "" do
  it "loads file" do
  	memory = Memory.new
    virtualMachine = VirtualMachine.new(memory)

    expect(memory).to receive(:load)
    virtualMachine.load_file_to_memory("./specs/assets/sample_game")
  end

  it "loads sprites" do
  	memory = Memory.new
    virtualMachine = VirtualMachine.new(memory)

    expect(memory.byte_at(0)).to eq("F0".hex)
    expect(memory.byte_at(36)).to eq("10".hex)
  end
end