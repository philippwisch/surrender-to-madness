extends Character

class_name Player

signal speed_update
signal move_input

@export var speed_increase = 2
@export var rp_drain_initial = 6.0			# per second
@export var rp_drain_increase = 0.3 		# also per second

var	rp_drain = rp_drain_initial
var last_input: String						# used to buffer user inputs
var game_running = false

func _ready():
	super._ready()
	init_signals()
	$AnimationPlayer.play("idle")


func _process(_delta):
	# change Player Sprite Color based on how high ressource power is
	var r = 77 + (255 - 77) * (100 - rp) / 100
	var g = 20 + (255 - 20) * (100 - rp) / 100
	var b = 111 + (255 - 111) * (100 - rp) / 100
	modulate = Color8(r,g,b)
	
	if game_running:
		super._process(_delta)
		move()
		cast()
		if hp == 0 or rp == 0:
			death.emit()


func emit_all():
	super.emit_all()
	speed_update.emit(speed)


func start_game():
	$SpeedIncrease.start()
	$ResourceDrain.start()
	game_running = true


func handle_cast_input():
	
	# quick and dirty handling of silence:
	# Silence is castable at any time, regardless of
	# what other spell is currently cast or how long it's cast has left
	if Input.is_action_pressed("ui_cast_extra2"):
		if $Silence.cd.time_left < 0.2:
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
	#move this method call to trigger on _input instead of every frame
	handle_cast_input()

	if last_input in spells:
		var cast_rdy = !cur_spell or cur_spell.cast.time_left == 0
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
				cast_finished.emit(0, "Silence")

		elif cast_rdy and cd_rdy:
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
			
			cast_finished.emit(cur_spell.damage, cur_spell.name)
			update_rp(cur_spell.rp_gain)
			update_hp(cur_spell.hp_gain)
			cur_spell.cast.start()
			cur_spell.cd.start()
			play("cast_end")
	
	update_cast()
	update_cds()


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


func init_signals():
		$SpeedIncrease.timeout.connect(_on_speed_increase_timeout)
		$ResourceDrain.timeout.connect(_on_resource_drain_timeout)
		animation_finished.connect(func():
			play("idle")
			)
