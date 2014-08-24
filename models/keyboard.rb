include "get_key"

class Keyboard

	def is_pressed?(key)
		GetKey.pressed == key.to_s(16)[0].ord
	end

end