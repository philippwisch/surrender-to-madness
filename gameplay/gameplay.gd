extends Node2D

class_name Gameplay

signal game_start

signal player_cast_update
signal player_cd_update
signal player_hp_update
signal player_rp_update
signal player_speed_update
signal player_death

signal boss_hp_update
signal boss_cast_update
signal boss_death

var player: Player
var boss: Boss
var boss_arena: BossArena

var player_game_position

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $Player
	boss = $Boss
	boss_arena = $BossArena
	init_signals()
	
	player_game_position = Vector2(1,1)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
	
func clamp_position_to_game_grid(pos):
	var res = Vector2(pos)
	if pos.x < boss_arena.GAME_POSITION_MIN.x:
		res.x = boss_arena.GAME_POSITION_MIN.x
	if pos.y < boss_arena.GAME_POSITION_MIN.y:
		res.y = boss_arena.GAME_POSITION_MIN.y
		
	if pos.x > boss_arena.GAME_POSITION_MAX.x:
		res.x = boss_arena.GAME_POSITION_MAX.x
	if pos.y > boss_arena.GAME_POSITION_MAX.y:
		res.y = boss_arena.GAME_POSITION_MAX.y
	return res
	
	
func _on_player_cast_update(cast_progress, cast_name):
	player_cast_update.emit(cast_progress, cast_name)


func _on_player_cd_update(progress):
	player_cd_update.emit(progress)


func _on_player_death():
	player_death.emit()


func _on_player_hp_update(hp):
	player_hp_update.emit(hp)


func _on_player_rp_update(rp):
	player_rp_update.emit(rp)


func _on_player_speed_update(speed):
	player_speed_update.emit(speed)


func _on_player_cast_finished(damage):
	boss.hp -= damage
	boss_hp_update.emit(float(boss.hp) / float(boss.hp_max))


func _on_player_move_input(dir: Vector2):
	var cur = player_game_position
	var new = cur + dir
	new = clamp_position_to_game_grid(new)
	player_game_position = new
	boss_arena.adjust_player_sprite(player,player_game_position)


func init_signals():
	player.cast_finished.connect(_on_player_cast_finished)
	player.cast_update.connect(_on_player_cast_update)
	player.cd_update.connect(_on_player_cd_update)
	player.death.connect(_on_player_death)	
	player.hp_update.connect(_on_player_hp_update)
	player.move_input.connect(_on_player_move_input)
	player.rp_update.connect(_on_player_rp_update)
	player.speed_update.connect(_on_player_speed_update)
