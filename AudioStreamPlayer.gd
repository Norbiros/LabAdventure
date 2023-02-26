extends AudioStreamPlayer

var rng = RandomNumberGenerator.new()
var songs = [
	load("res://Sounds/medieval_loop.wav"),
	load("res://Sounds/Shepherd_dog.wav"),
	load("res://Sounds/gem_kings_gallery.mp3"),
	load("res://Sounds/pretty-maiden-mageonduty.mp3")
]
var i = 0

func _ready():
	next_song()

func next_song():

	rng.randomize()
	var i = rng.randf_range(0, len(songs))
	self.stream = songs[i]
	play(0.0)

func _on_AudioStreamPlayer_finished():
	next_song()
