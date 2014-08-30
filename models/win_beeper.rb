require "win32/sound"
include Win32

class WinBeeper
	def start
		Sound.play('beep.wav', Sound::ASYNC | Sound::LOOP)
	end

	def end
		Sound.stop
	end
end