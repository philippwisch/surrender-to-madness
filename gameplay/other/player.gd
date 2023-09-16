extends Character

class_name Player

signal speed_update
signal death
signal cast_finished
signal move_input

@export var speed_increase = 2
@export var rp_drain_initial = 6.0			# per second
@export var rp_drain_increase = 0.3 		# also per second

var	rp_drain = rp_drain_initial
var last_input: String						# used to buffer user inputs


func _ready():
	super._ready()
	init_signals()
	
	#Main.game_start.connect(_on_gameplay_game_start)
	# For now Manual call just for testing
	_on_gameplay_game_start()
	

func _process(_delta):
	super._process(_delta)
	move()
	cast()
	
	if hp == 0 or rp == 0:
		death.emit()


func handle_cast_input():
	
	# quick and dirty handling of silence:
	# Silence is castable at any time, regardless of
	# what other spell is currently cast or how long it's cast has left
	if Input.is_action_pressed("ui_cast_extra2"):
		if $Silence.cd.time_left < 1:
			last_input = "Silence"
	
	# spell inputs are "buffered" starting at 200ms before the GlobalCooldown ends
	if !cur_spell or cur_spell.cast.time_left < 0.2:
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


func move():
	var dir = get_move_direction()
	move_input.emit(dir)
	
	
func cast():
	#move this to _input
	handle_cast_input()

	if last_input in spells:
		var cast_rdy = true if !cur_spell else cur_spell.cast.time_left == 0
		var cd_rdy = spells[last_input].cd.time_left == 0
		
	# quick and dirty handling of silence:
	# Silence is castable at any time, regardless of
	# what other spell is currently cast or how long it's cast has left
	# Silence doesn't trigger a cast like other spells
	# In WoW terms it doesn't trigger a GCD and is instant
		if last_input == "Silence":
			if cd_rdy:
				play_spell_sound("Silence")
				last_input = ""
				$Silence.cd.start()

		elif cast_rdy && cd_rdy:
			cur_spell = spells[last_input]
			play_spell_sound(cur_spell.name)
			
			if cur_spell.can_speed_up:
				# update cast & cd based on current speed
				var speed_factor = 100.0 / speed
				var new_cd =  speed_factor * cur_spell.cd_original
				cur_spell.cd.set_wait_time(new_cd)
				var new_cast = speed_factor * cur_spell.cast_original
				cur_spell.cast.set_wait_time(new_cast)

			last_input = ""
			
			cast_finished.emit(cur_spell.damage)
			update_rp(cur_spell.rp_gain)
			update_hp(cur_spell.hp_gain)
			cur_spell.cast.start()
			cur_spell.cd.start()
	
	update_cast()
	update_cds()


# move this to boss arena and call it from encounter



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
	
# TODO
func _on_gameplay_game_stop():
	# reset drain speed hp etc
	pass
	
func init_signals():
		$SpeedIncrease.timeout.connect(_on_speed_increase_timeout)
		$ResourceDrain.timeout.connect(_on_resource_drain_timeout)
