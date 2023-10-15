extends Node2D

class_name Arena

# Default Layout will be 4x4

# maybe make a method here in super that will just push 2 given vectors into
# this kind of structure idk

# Format is {Game Position : Screen Position}
var game_position_to_screen_position = {
	Vector2(1,2): Vector2(500,600),
	Vector2(2,2): Vector2(1100,600),
	Vector2(1,1): Vector2(300,850),
	Vector2(2,1): Vector2(1300,850),
}

#make a method to set this as well

# Format is {Game Y Position : Scalefactor}
var position_y_to_scale_factor_player = {
	1: 1,
	2: 0.65
}

var position_y_to_scale_factor_position_markers = {
	1: 4,
	2: 2
}

var GAME_POSITION_MIN = Vector2(1,1)
var GAME_POSITION_MAX = Vector2(2,2)

var BOSS_POSITION


# Called when the node enters the scene tree for the first time.
func _ready():
	BOSS_POSITION = get_viewport_rect().size / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func set_game_position_to_screen_position(game_position: Vector2, screen_position: Vector2):
	game_position_to_screen_position[game_position] = screen_position


func adjust_player_sprite(sprite, game_position: Vector2):
	adjust_sprite_position(sprite, game_position)
	adjust_sprite_scale(sprite, game_position, position_y_to_scale_factor_player)
	adjust_sprite_flip(sprite, game_position)
	
func adjust_sprite_position(sprite, game_position: Vector2):
	var new_pos = game_position_to_screen_position[game_position]
	sprite.position = new_pos

# called by boss_encounter for example to scale the player sprite or
# other elements in the boss arena
func adjust_sprite_scale(sprite, game_position: Vector2, position_y_to_scale_factor):
	var scale_factor = position_y_to_scale_factor[int(game_position.y)]
	sprite.scale.x = scale_factor
	sprite.scale.y = scale_factor


func adjust_sprite_flip(sprite, game_position: Vector2):
	# flip vertically if on the right side
	if game_position.x == GAME_POSITION_MAX.x / 2:
		sprite.set_flip_h(false)
		pass
	else:
		sprite.set_flip_h(true)
		pass	


func add_position_markers(marker_path):
	for GAME_POSITION in game_position_to_screen_position:
		var marker = load(marker_path).instantiate()
		add_child(marker)
		marker.position = game_position_to_screen_position[GAME_POSITION]
		adjust_sprite_scale(marker, GAME_POSITION, position_y_to_scale_factor_position_markers)
