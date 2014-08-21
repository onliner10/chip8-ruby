require "./models/cpu"
require "./models/stack"
require "./specs/helpers/cpu_helper"

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

  it "throws exception when method_missing's name is not opcode" do
    memory = CpuTestHelper::memory_with_single_opcode("111111111")
    cpu = CPU.new(memory)

    expect{cpu.A_NOT_EXISTING_AND_NOT_OPCODE}.to raise_error(NoMethodError)
  end

  it "should not preserve helper variables between opcodes" do
    memory = Memory.new

    #Set V1 = 11
    memory.load("200".hex, "61".to_i(16))
    memory.load("201".hex, "11".to_i(16))

    # Set V2 = V1
    memory.load("202".hex, "82".to_i(16))
    memory.load("203".hex, "10".to_i(16))

    # Mocked opcode
    memory.load("204".hex, "91".to_i(16))
    memory.load("205".hex, "16".to_i(16))

    cpu = CPU.new(memory)
    3.times { cpu.do_cycle }

    helper_methods = cpu.instance_variable_get(:@helper_methods)
    expect(helper_methods).to eq([:var_K, :registry_K, :registry_K=])
  end

  class CPU
    def opcode_9XY9(helper)
      self.VE = helper.registry_X
      self.VF = helper.registry_Y
    end

    def opcode_9X98(helper)
      helper.registry_X = 2
    end

    def opcode_9KK7(helper)
      self.VE = helper.var_K
    end

    def opcode_9KK6(helper)
      @helper_methods = helper.methods.grep(/(var|registry)\_[F-Z]/)
    end
  end
end