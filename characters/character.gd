extends AnimatedSprite2D

class_name Character

signal hp_update
signal rp_update
signal cast_update
signal cd_update

@export var hp_max = 100
@export var hp_regen_value = 1
@export var hp_regen_cd = 1

@export var rp_max = 100

@export var speed_max = 200
@export var speed_initial = 100
@export var gcd_initial = 1.5

var hp = hp_max
var rp = rp_max
var speed = speed_initial	# basically haste from wow

var gcd: Timer
var hp_regen: Timer
var spells = {}
var sounds = {}
var current_cast: String	# used to display as text


func _init():
	pass

func _ready():
	gcd = $GlobalCooldown
	hp_regen = $HitPointRegeneration
	
	var children = get_children()
	for child in children:
		if child is Spell:
			spells[child.name] = child
			print(child)
		if child is AudioStreamPlayer:
			sounds[child.name] = child


func _process(_delta):
	pass
	
func update_hp(diff_val):
	hp += diff_val
	
	if hp < 0:
		hp = 0
	if hp > hp_max:
		hp = hp_max

	hp_update.emit(hp)


func update_rp(diff_val):
	rp += diff_val
	
	if rp < 0:
		rp = 0
	if rp > rp_max:
		rp = rp_max

	rp_update.emit(rp)	


func update_cast():
	# change this to cast time!
	var cast_progress = (gcd.time_left / gcd.get_wait_time())
	var cast_name = current_cast
	cast_update.emit(cast_progress, cast_name)


func update_cds():
	var progress = {}
	
	for key in spells:
		var cd = spells[key].cd
		var p = cd.time_left / cd.get_wait_time()
		progress[key] = p

	cd_update.emit(progress)


func recalculate_cds():
	var speed_factor = 100.0 / speed

	var new_gcd = speed_factor * gcd_initial
	gcd.set_wait_time(new_gcd)
	
	var new_heal_cd = speed_factor * hp_regen_cd
	hp_regen.set_wait_time(new_heal_cd)
	

	for key in spells:
		var s = spells[key]
		if s.can_speed_up:
			var new_cd =  speed_factor * s.cd_original
			s.cd.set_wait_time(new_cd)


func play_spell_sound(spell_name):
	var key = "Sound " + spell_name
	if key in sounds:
		sounds[key].play()


func _on_hit_point_regeneration_timeout():
	update_hp(hp_regen_value)
