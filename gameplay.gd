extends Node2D

signal game_start

const GAME_POSITIONS = {
	"NW": Vector2(0,1),
	"NE": Vector2(1,1),
	"SW": Vector2(0,0),
	"SE": Vector2(1,0),
}
const SCREEN_POSITIONS = {
	"NW": Vector2(500,600),	#NW
	"NE": Vector2(1100,600),	#NE
	"SW": Vector2(300,850),	#SW
	"SE": Vector2(1300,850),	#SE
}



# Called when the node enters the scene tree for the first time.
func _ready():
	#add_position_markers()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func start_game():
	game_start.emit()



func transform_game_grid_position_to_screen_position(pos):
	for i in GAME_POSITIONS:
		if GAME_POSITIONS[i] == pos:
			return SCREEN_POSITIONS[i]
