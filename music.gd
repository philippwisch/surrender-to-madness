extends AudioStreamPlayer

func _ready():
	# For some reason, setting this in Inspector directly does not work
	# So it's set here.
	# I wonder if this has something to do with this node being autoload
	Music.bus = "Music"
	Music.process_mode = Node.PROCESS_MODE_ALWAYS


func load_and_play(audio_file_path, from_position = 0.0):
	var sfx = load(audio_file_path) 
	sfx.set_loop(true)
	Music.stream = sfx
	Music.play(from_position)
