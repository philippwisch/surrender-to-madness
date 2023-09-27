extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func load_and_play(audio_file_path, from_position = 0.0):
	var sfx = load(audio_file_path) 
	sfx.set_loop(true)
	Music.stream = sfx
	Music.bus = "Music"
	Music.play(from_position)
