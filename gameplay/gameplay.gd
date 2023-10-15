extends Node2D

class_name Gameplay

signal countdown

signal player_cast_finished
signal player_cast_update
signal player_cd_update
signal player_hp_update
signal player_rp_update
signal player_speed_update

signal boss_cast_finished
signal boss_hp_update
signal boss_cast_update

signal game_victory
signal game_defeat

var player: Player
var boss: Boss
var arena: Arena

var player_game_position

# used when starting the game
var countdown_timer: Timer
var countdown_progress: int


func pause_game():
	get_tree().paused = true
	
func unpause_game():
	get_tree().paused = false


func start_game(boss_name):
	prepare_game(boss_name)
	
	create_countdown_timer()
	
	# emit once at the start so the 3 shows up instantly
	countdown.emit(str(countdown_progress))
	countdown_timer.start()


func create_countdown_timer():
	countdown_progress = 3
	countdown_timer = Timer.new()
	add_child(countdown_timer)
	countdown_timer.one_shot = true
	countdown_timer.timeout.connect(on_countdown_timeout)	


func on_countdown_timeout():
	if countdown_progress > 1:
		countdown_progress -= 1
		countdown_timer.start()
		countdown.emit(str(countdown_progress))
	else:
		player.start_game()
		boss.start_game()
		countdown.emit("")


func prepare_game(boss_name):
	var b_path = "res://gameplay/bosses/" + boss_name + ".tscn"
	boss = reload_child_scene(b_path, boss)
	
	var a_path = boss.arena_path
	arena = reload_child_scene(a_path, arena)
	
	var p_path = "res://gameplay/other/player.tscn"
	player = reload_child_scene(p_path, player)
	
	init_signals() # Connect Signals AFTER all nodes have been created
	
	# the HUD needs to be initialized with initial values from boss and player
	player.emit_all()
	boss.emit_all()
	
	boss.global_position = arena.BOSS_POSITION
	player_game_position = Vector2(1,1)
	# run move once to move player to starting position
	player.move()


func reload_child_scene(scene_path: String, node_reference: Node):
	var ref = node_reference
	
	if ref:
		ref.queue_free()
	var scene = load(scene_path)
	ref = scene.instantiate()
	add_child(ref)
	return ref


# area of effect should be an array of Vector2 corresponding to all the
# locations the boss ability will hit
func _on_boss_cast_finished(damage, area_of_effect):
	if player_game_position in area_of_effect:
		player.update_hp(-damage)
	
	boss_cast_finished.emit()

func _on_boss_cast_update(cast_progress, cast_name):
	boss_cast_update.emit(cast_progress, cast_name)


func _on_boss_death():
	game_victory.emit()


func _on_boss_hp_update(hp):
	boss_hp_update.emit(float(hp) / float(boss.hp_max))


func _on_player_cast_finished(damage, cast_name):
	if cast_name == "Silence":
		boss.interrupt_cast()
		boss_cast_update.emit(1, "Interrupted")
	boss.update_hp(-damage)
	
	player_cast_finished.emit()


func _on_player_cast_update(cast_progress, cast_name):
	player_cast_update.emit(cast_progress, cast_name)


func _on_player_cd_update(progress):
	player_cd_update.emit(progress)


func _on_player_death():
	game_defeat.emit()


func _on_player_hp_update(hp):
	player_hp_update.emit(float(hp) / float(player.hp_max))


func _on_player_move_input(dir: Vector2):
	var cur = player_game_position
	var new = cur + dir
	new = clamp_position_to_game_grid(new)
	player_game_position = new
	arena.adjust_player_sprite(player,player_game_position)


func _on_player_rp_update(rp):
	player_rp_update.emit(float(rp) / float(player.rp_max))


func _on_player_speed_update(speed):
	player_speed_update.emit(speed)


func init_signals():
	boss.cast_finished.connect(_on_boss_cast_finished)
	boss.cast_update.connect(_on_boss_cast_update)
	boss.death.connect(_on_boss_death)
	boss.hp_update.connect(_on_boss_hp_update)
	
	player.cast_finished.connect(_on_player_cast_finished)
	player.cast_update.connect(_on_player_cast_update)
	player.cd_update.connect(_on_player_cd_update)
	player.death.connect(_on_player_death)	
	player.hp_update.connect(_on_player_hp_update)
	player.move_input.connect(_on_player_move_input)
	player.rp_update.connect(_on_player_rp_update)
	player.speed_update.connect(_on_player_speed_update)


func clamp_position_to_game_grid(pos):
	var res = Vector2(pos)
	if pos.x < arena.GAME_POSITION_MIN.x:
		res.x = arena.GAME_POSITION_MIN.x
	if pos.y < arena.GAME_POSITION_MIN.y:
		res.y = arena.GAME_POSITION_MIN.y
		
	if pos.x > arena.GAME_POSITION_MAX.x:
		res.x = arena.GAME_POSITION_MAX.x
	if pos.y > arena.GAME_POSITION_MAX.y:
		res.y = arena.GAME_POSITION_MAX.y
	return res
