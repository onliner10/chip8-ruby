require "./models/memory"

describe Memory, "#load" do
  it "loads data to memory" do
    memory = Memory.new

    data_to_load = Array.new(230)
    data_to_load.each { |e| e = 166 }

    memory.load("200".hex, data_to_load)

  end
end