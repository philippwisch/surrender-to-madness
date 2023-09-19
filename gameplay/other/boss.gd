extends Character

class_name Boss

var area_of_effect = []

var game_running = false

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if game_running:
		super._process(_delta)
		cast()
	
	
func start_game():
	game_running = true


func cast():
	# First check if a cast has been started on a previous process cycle
	# And check if the cast has finished on this cycle
	if cur_spell and cur_spell.cast_just_finished:
			cast_finished.emit(cur_spell.damage, area_of_effect)
			cur_spell.cast_just_finished = false

	# After that check if a spell can currently be cast or if there still is a cooldown
	
	# difference gcd and cd:
	# gcd -> time before ANY spell can be cast / cd -> time before THIS spell can be cast
	if !cur_spell or cur_spell.gcd_ready:
		cur_spell = null
	# find the spell with a finished cooldown with the highest priority
		var highest_spell_priority = 0
		for key in spells:
			var spell = spells[key]

			if spell.cd_ready and ( spell.priority > highest_spell_priority ):
				cur_spell = spell
			
		# check for null because there might not be any spell whose cooldown is ready
		if cur_spell:
			cur_spell.start_timers()
			# this will be used in subclasses to change the spell's
			# behavior, play animations etc
			cast_started.emit()
			
	update_cast()


func interrupt_cast():
	cur_spell = null
