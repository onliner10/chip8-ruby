require "./models/display"

describe Display, "" do

	it "can draw sprites (no collision)" do
		display = Display.new
		collision = display.draw_sprite([0,1,1,0,0,0,1,0], :x => 2, :y => 2)

		buffer = display.buffer

		expect(collision).to eq(0)
		expect(buffer[2][2..9]).to eq([0,1,1,0,0,0,1,0])
	end

	it "can draw sprites (THERE IS collision)" do
		display = Display.new
		display.draw_sprite([0,1,1,0,0,0,1,0], :x => 2, :y => 2)
		collision = display.draw_sprite([0,1,1,0,0,0,1,0], :x => 3, :y => 2)

		buffer = display.buffer

		expect(collision).to eq(1)
		expect(buffer[2][2..11]).to eq([0,1,0,1,0,0,1,1,0,0])
	end

	it "draws from the opposite when going out of the screen (RIGHT)" do
		display = Display.new
		display.draw_sprite([0,1,1,0,0,0,1,0], :x => 60, :y => 2)

		buffer = display.buffer

		expect(buffer[2][60..63]).to eq([0,1,1,0])
		expect(buffer[2][0..3]).to eq([0, 0,1,0])
	end

	it "draws from the opposite when going out of the screen (BOTTOM)" do
		display = Display.new
		display.draw_sprite([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1], :x => 30, :y => 31)

		buffer = display.buffer

		expect(buffer[31][30..37]).to eq([1,1,1,1,1,1,1,1])
		expect(buffer[0][30..37]).to eq([1,1,1,1,1,1,1,1])
	end
end