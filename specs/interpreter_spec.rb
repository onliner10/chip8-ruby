require "./models/interpreter"
require "./models/stack"
require "./specs/helpers/interpreter_helper"

describe Interpreter, "execute creates helpers for opcodes" do

	it "creates temporary value helpers for each opcode (getters)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("9117")

    interpreter = Interpreter.new(memory)
    interpreter.execute

    expect(interpreter.VE).to eq("11".to_i(16))
  end

  it "creates temporary register helpers for each opcode (getters)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("9129")

    interpreter = Interpreter.new(memory)
    interpreter.V1 = 11
    interpreter.V2 = 22
    interpreter.execute

    expect(interpreter.VE).to eq(11)
    expect(interpreter.VF).to eq(22)
  end

  it "creates temporary register helpers for each opcode (setters)" do
    memory = InterpreterTestHelper::memory_with_single_opcode("9198")

    interpreter = Interpreter.new(memory)
    interpreter.V1 = 1
    interpreter.execute

    expect(interpreter.V1).to eq(2)
  end

  it "throws exception when method_missing's name is not opcode" do
    memory = InterpreterTestHelper::memory_with_single_opcode("111111111")
    interpreter = Interpreter.new(memory)

    expect{interpreter.A_NOT_EXISTING_AND_NOT_OPCODE}.to raise_error(NoMethodError)
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

    interpreter = Interpreter.new(memory)
    3.times { interpreter.execute }

    helper_methods = interpreter.instance_variable_get(:@helper_methods)
    expect(helper_methods).to eq([:var_K, :registry_K, :registry_K=])
  end

  class Interpreter
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