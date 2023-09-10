extends Character

signal speed_update
signal death
signal cast_finished

@export var speed_increase = 2
@export var rp_drain_initial = 6.0			# per second
@export var rp_drain_increase = 0.3 		# also per second

var	rp_drain = rp_drain_initial
var last_input: String						# used to buffer user inputs

#QUESTION INIT THIS HERE OR NOT? THIS MIGHT NEED TO CHANGE LATER
var game_grid_position = Vector2.ZERO

func _ready():
	super._ready()
	Gameplay.game_start.connect(_on_gameplay_game_start)


func _process(_delta):
	super._process(_delta)
	move()
	cast()
	
	if hp == 0 or rp == 0:
		death.emit()


func handle_cast_input():
	# spell inputs are "buffered" starting at 200ms before the GlobalCooldown ends
	if !current_spell or current_spell.cast.time_left < 0.2:
		if Input.is_action_pressed("ui_cast1"):
			last_input = "Mind Flay"
		if Input.is_action_pressed("ui_cast2"):
			last_input = "Void Bolt"
		if Input.is_action_pressed("ui_cast3"):
			last_input = "Mind Blast"
		if Input.is_action_pressed("ui_cast4"):
			last_input = "Shadow Word Death"
		if Input.is_action_pressed("ui_cast_extra1"):
			last_input = "Shadow Mend"
		if Input.is_action_pressed("ui_cast_extra2"):
			last_input = "Healing Potion"			


func move():
	var dir = get_move_direction()
	var cur = game_grid_position 	# current player position
	var new = cur + dir
	new = clamp_position_to_game_grid(new)
	
	game_grid_position = new
	adjust_sprite(game_grid_position)
	
	position = Gameplay.transform_game_grid_position_to_screen_position(new)


func cast():
	handle_cast_input()

	if last_input in spells:
		var cast_rdy = true if !current_spell else current_spell.cast.time_left == 0
		var cd_rdy = spells[last_input].cd.time_left == 0
		
		if cast_rdy && cd_rdy:
			var spell: Spell = spells[last_input]
			play_spell_sound(spell.name)
			current_spell = spells[last_input]
			last_input = ""
			
			cast_finished.emit(spell.damage)
			update_rp(spell.rp_gain)
			update_hp(spell.hp_gain)
			current_spell.cast.start()
			spell.cd.start()
	
	update_cast()
	update_cds()

# move this to boss encounter
func clamp_position_to_game_grid(pos):
	var res = Vector2(pos)
	if pos.x < 0:
		res.x = 0
	if pos.y < 0:
		res.y = 0
		
	if pos.x > 1:
		res.x = 1
	if pos.y > 1:
		res.y = 1
	return res

# move this to boss arena and call it from encounter
func adjust_sprite(pos):
	# scale down if far away
	if pos.y == 1:
		scale.x = 0.65
		scale.y = 0.65
	else:
		scale.x = 1.8
		scale.y = 1.8
		
	# flip vertically if on the right side
	if pos.x == 1:
		set_flip_h(true)
	else:
		set_flip_h(false)


func get_move_direction():
	var dir = Vector2.ZERO		# direction
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_down"):
		dir.y -= 1
	if Input.is_action_pressed("ui_up"):
		dir.y += 1
	return dir			


func _on_speed_increase_timeout():
	rp_drain += rp_drain_increase
	if speed < speed_max:
		speed = min(speed + speed_increase, 200)
	
	speed_update.emit(speed)


func _on_resource_drain_timeout():
	update_rp(- rp_drain / 10)


func _on_gameplay_game_start():
	$SpeedIncrease.start()
	$ResourceDrain.start()
