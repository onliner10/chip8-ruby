require "./models/cpu"
require "./models/stack"
require "./specs/helpers/cpu_helper"

describe CPU, "stack commands" do

	it "can call subroutines (2NNN)" do
    memory = CpuTestHelper::memory_with_single_opcode("2250")

    stack = Stack.new
    cpu = CPU.new(memory, stack)
    cpu.do_cycle

    expect(stack.pop).to eq("202".to_i(16))
    expect(cpu.PC).to eq("250".to_i(16))
  end

  it "can return from subroutines (00EE)" do
    memory = CpuTestHelper::memory_with_single_opcode("00EE")
    stack = Stack.new
    stack.push("250".to_i(16))

    cpu = CPU.new(memory, stack)
    cpu.do_cycle

    expect(cpu.PC).to eq("250".to_i(16))
  end

end