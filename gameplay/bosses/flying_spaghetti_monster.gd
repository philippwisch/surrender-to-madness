extends Boss


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	super._process(_delta)
	
func cast():
	pass

# TODO keep going here
func _on_timer_eye_beam_timeout():
	spells["Eye Beam"]
	#current_cast = "Eye Beam"
	#update_cast()	
