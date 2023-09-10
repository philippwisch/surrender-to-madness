extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#add_position_markers()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func add_position_markers():
	for i in Gameplay.SCREEN_POSITIONS:
		var marker = preload("res://sprites/column.tscn").instantiate()
		add_child(marker)
		marker.position = Gameplay.SCREEN_POSITIONS[i]
		if Gameplay.GAME_POSITIONS[i].y == 1:
			marker.scale.x = 2
			marker.scale.y = 2
		else:
			marker.scale.x = 4
			marker.scale.y = 4
