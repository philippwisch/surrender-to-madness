extends Arena

var prog=0
var speed=0.005

# Called when the node enters the scene tree for the first time.
func _ready():
	add_position_markers("res://sprites/column.tscn")


# Called every frame. 'delta' is the elapsed time sproge the previous frame.
func _process(delta):
	if prog < 1:
		prog+=delta*speed
		$Path2D/PathFollow2D.progress_ratio = min(prog, 1)
