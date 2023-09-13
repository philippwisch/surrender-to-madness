extends Node2D

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
	#add_position_markers("res://sprites/column.tscn")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# called by boss_encounter for example to scale the player sprite or
# other elements in the boss arena
func distance_scale_sprite(sprite: Sprite2D):
	var _shutupcompiler = sprite
	pass

func add_position_markers(marker_path):
	for i in SCREEN_POSITIONS:
		var marker = load(marker_path).instantiate()
		add_child(marker)
		marker.position = SCREEN_POSITIONS[i]
		if GAME_POSITIONS[i].y == 1:
			marker.scale.x = 2
			marker.scale.y = 2
		else:
			marker.scale.x = 4
			marker.scale.y = 4
			
func transform_game_grid_position_to_screen_position(pos):
	for i in GAME_POSITIONS:
		if GAME_POSITIONS[i] == pos:
			return SCREEN_POSITIONS[i]			