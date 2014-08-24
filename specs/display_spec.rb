require "./models/display"

describe Display, "" do

	it "can return sprites" do
		expect(Display.sprites[0]).to eq("F0".hex)
    	expect(Display.sprites[36]).to eq("10".hex)
	end

	it "can return sprite offset" do
		expect(Display.sprite_offset_for("B".hex)).to eq(55)
    	expect(Display.sprite_offset_for("0".hex)).to eq(0)
	end

	it "raises exception when trying to draw outside the screen" do
		display = Display.new
		
		expect{display.draw_sprite([1], :x => 30, :y => 33)}.to raise_error(ArgumentError)
		expect{display.draw_sprite([1], :x => 65, :y => 25)}.to raise_error(ArgumentError)
	end

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

	it "can clear the display" do
		display = Display.new
		display.draw_sprite([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1], :x => 30, :y => 31)
		display.draw_sprite([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1], :x => 40, :y => 0)

		display.clear

		display.buffer.each do |row|
			row.each { |cell| expect(cell).to eq(0)  }
		end
	end
end