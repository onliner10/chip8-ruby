require "./models/cpu"
require "./models/stack"
require "./specs/helpers/cpu_helper"

describe CPU, "input commands" do

	it "can do conditional skip based on input (EX9E - key NOT pressed)" do
	    memory = CpuTestHelper::memory_with_single_opcode("E19E")
	    keyboard_mock = CpuTestHelper::keyboard_mock

	    cpu = CPU.new(memory, Stack.new, keyboard_mock)
	    cpu.V1 = 3

	    cpu.do_cycle

	    expect(cpu.PC).to eq("202".to_i(16))
	end

	it "can do conditional skip based on input (EX9E - key IS pressed)" do
	    memory = CpuTestHelper::memory_with_single_opcode("E19E")
	    keyboard_mock = CpuTestHelper::keyboard_mock
	    keyboard_mock.press(3)

	    cpu = CPU.new(memory, Stack.new, keyboard_mock)
	    cpu.V1 = 3

	    cpu.do_cycle

	    expect(cpu.PC).to eq("204".to_i(16))
	end

	it "can do conditional skip based on input (EXA1  - key NOT pressed)" do
	    memory = CpuTestHelper::memory_with_single_opcode("E1A1")
	    keyboard_mock = CpuTestHelper::keyboard_mock

	    cpu = CPU.new(memory, Stack.new, keyboard_mock)
	    cpu.V1 = 3

	    cpu.do_cycle

	    expect(cpu.PC).to eq("204".to_i(16))
	end

	it "can do conditional skip based on input (EXA1  - key IS pressed)" do
	    memory = CpuTestHelper::memory_with_single_opcode("E1A1")
	    keyboard_mock = CpuTestHelper::keyboard_mock
	    keyboard_mock.press(3)

	    cpu = CPU.new(memory, Stack.new, keyboard_mock)
	    cpu.V1 = 3

	    cpu.do_cycle

	    expect(cpu.PC).to eq("202".to_i(16))
	end

	it "can wait for key press (FX0A  - key NOT pressed - should not change PC)" do
	    memory = CpuTestHelper::memory_with_single_opcode("F10A")
	    keyboard_mock = CpuTestHelper::keyboard_mock

	    cpu = CPU.new(memory, Stack.new, keyboard_mock)
	    cpu.do_cycle

	    expect(cpu.PC).to eq("200".to_i(16))
	end

	it "can wait for key press (FX0A  - key IS pressed - should change PC and store key in register)" do
	    memory = CpuTestHelper::memory_with_single_opcode("F10A")
	    keyboard_mock = CpuTestHelper::keyboard_mock
	    keyboard_mock.press("A".hex)

	    cpu = CPU.new(memory, Stack.new, keyboard_mock)
	    cpu.do_cycle

	    expect(cpu.PC).to eq("202".to_i(16))
	    expect(cpu.V1).to eq("A".hex)
	end

end