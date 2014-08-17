require "./models/cpu"
require "./specs/helpers/cpu_helper"

class CPU
	def opcode_9XY9
		self.VE = registry_X
		self.VF = registry_Y
	end

	def opcode_9X98
		self.registry_X = 2
	end

	def opcode_9KK7
		self.VE = var_K
	end
end

describe CPU, "do_cycle creates helpers for opcodes" do

	it "creates temporary value helpers for each opcode (getters)" do
    memory = CpuTestHelper::memory_with_single_opcode("9117")

    cpu = CPU.new(memory)
    cpu.do_cycle

    expect(cpu.VE).to eq("11".to_i(16))
  end

  it "creates temporary register helpers for each opcode (getters)" do
    memory = CpuTestHelper::memory_with_single_opcode("9129")

    cpu = CPU.new(memory)
    cpu.V1 = 11
    cpu.V2 = 22
    cpu.do_cycle

    expect(cpu.VE).to eq(11)
    expect(cpu.VF).to eq(22)
  end

  it "creates temporary register helpers for each opcode (setters)" do
    memory = CpuTestHelper::memory_with_single_opcode("9198")

    cpu = CPU.new(memory)
    cpu.V1 = 1
    cpu.do_cycle

    expect(cpu.V1).to eq(2)
  end

end