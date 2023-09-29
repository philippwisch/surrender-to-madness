extends Boss

var beam_direction

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	init_signals()
	arena_path = "res://gameplay/arenas/arena_space.tscn"
	
	# manually force cd so the first ability the boss uses is not a heal at
	# full hp
	spells["Slurping Sauce"].cd.start()
	spells["Slurping Sauce"].cd_ready = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	super._process(_delta)


func _on_cast_started():
	$"Eye Beam Left".visible = false
	$"Eye Beam Right".visible = false
	
	# can the following code be prettied up
	# only thing i can think of is maybe using a dictionary
	if cur_spell.name == "Eye Beam":
		eye_beam_start()
	elif cur_spell.name == "Slurping Sauce":
		slurping_sauce_start()



func _on_cast_finished(_dam, _aoe):
	$"Sound Eye Beam Precast".stop()
	if cur_spell.name == "Eye Beam":
		eye_beam_end()
	elif cur_spell.name == "Slurping Sauce":
		slurping_sauce_end()


func eye_beam_start():
	play_spell_sound("Eye Beam Precast")
	beam_direction = randi_range(0,1)
	
	# left
	if beam_direction == 0:
		area_of_effect = [
			Vector2(1,1),
			Vector2(1,2)
		]
		flip_h = false
	# right
	else:
		area_of_effect = [
			Vector2(2,1),
			Vector2(2,2)
		]
		flip_h = true


func eye_beam_end():
	play_spell_sound("Eye Beam Postcast")
	if beam_direction == 0:
		$"Eye Beam Left".visible = true
	else:
		$"Eye Beam Right".visible = true

func slurping_sauce_start():
	play_spell_sound("Slurping Sauce")
	# Integer division, because hp is int
	hp_regen_value = hp_max / 100
	
func slurping_sauce_end():
	hp_regen_value = 0


func interrupt_cast():
	super.interrupt_cast()
	# special handling for slurping sauce: reset regeneration timer to zero
	hp_regen_value = 0
	
# can you connect in super and the connection will still hold if you overwrite it
# in a subclass?
# Then this code could be moved
func init_signals():
	cast_started.connect(_on_cast_started)
	cast_finished.connect(_on_cast_finished)
