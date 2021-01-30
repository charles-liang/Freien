extends AudioStreamPlayer



		
func play_signal(id, sound):
	self.stream = load("res://Sounds/%s.wav" % sound)
	self.play()
