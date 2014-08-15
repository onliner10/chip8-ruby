require "./models/virtual_machine"

describe VirtualMachine, "#load_file_to_memory" do
  it "loads file" do
  	memory = Memory.new
    virtualMachine = VirtualMachine.new(memory)

    expect(memory).to receive(:load)
    virtualMachine.load_file_to_memory("./specs/assets/sample_game")
  end
end