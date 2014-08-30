require "./models/timer"

describe Timer, "" do
	it "should be able to set timer value and decrease to zero" do
		timer = Timer.new
		timer.set(2)

		expect(timer.value).to eq(2)
		sleep(5.0 / 60.0)
		expect(timer.value).to eq(0)
	end

	it "should decrease at 60Hz" do
		timer = Timer.new
		timer.set(100)
		sleep(1.0 / 60.0 * 10)

		expect(timer.value).to be_between(89,91)
	end

	it "should execute specific action when timer reaches zero" do
		is_it_working = false

		timer = Timer.new
		timer.when_complete { is_it_working = true }
		timer.set(5)
		sleep(10.0 / 60.0)

		expect(is_it_working).to eq(true)
	end

	it "should execute specific action when timer activated" do
		is_it_working = false

		timer = Timer.new
		timer.when_activated { is_it_working = true }
		timer.set(100)

		expect(is_it_working).to eq(true)
	end
end