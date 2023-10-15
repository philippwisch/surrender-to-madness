extends Arena

var prog=0
var speed=0.005

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	position_y_to_scale_factor_player = {1: 0.65, 2: 0.5}
	position_y_to_scale_factor_position_markers = {1: 3, 2: 1.5}
	add_position_markers("res://sprites/column.tscn")	


# Called every frame. 'delta' is the elapsed time sproge the previous frame.
func _process(delta):
	if prog < 1:
		prog+=delta*speed
		$Path2D/PathFollow2D.progress_ratio = min(prog, 1)
