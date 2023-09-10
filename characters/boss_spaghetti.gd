extends Character

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func cast():
	pass

# TODO keep going here
func _on_timer_eye_beam_timeout():
	spells["Eye Beam"]
	current_cast = "Eye Beam"
	#update_cast()
