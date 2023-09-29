extends AnimatedSprite2D

class_name Character

signal cast_finished
signal cast_update
signal cast_started
signal cd_update
signal death
signal hp_update
signal rp_update


## Maximum Hit Points
@export var hp_max = 100
@export var hp_regen_value: int = 1
@export var hp_regen_cd: float = 1
## Maximum Ressource Power
@export var rp_max = 100

@export var speed_max = 200
@export var speed_initial = 100

var hp: int
var rp: int
var speed: int # basically haste from wow

var hp_regen: Timer
var cur_spell: Spell
var spells = {}
var sounds = {}

func _ready():
	hp = hp_max
	rp = rp_max
	speed = speed_initial
	hp_regen = $HitPointRegeneration
	
	hp_regen.timeout.connect(_on_hit_point_regeneration_timeout)
	
	var children = get_children()
	for child in children:
		if child is Spell:
			spells[child.name] = child
		if child is AudioStreamPlayer:
			sounds[child.name] = child
	
	update_hp_regen_cd()


func _process(_delta):
	update_hp_regen_cd()


func emit_all():
	update_hp(hp_max)
	update_rp(rp_max)
	update_cast()
	update_cds()


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
	if cur_spell:
		var cast_progress = (cur_spell.cast.time_left / cur_spell.cast.get_wait_time())
		var cast_name = cur_spell.name
		cast_update.emit(cast_progress, cast_name)
	else:
		cast_update.emit(1,"")


func update_cds():
	var progress = {}
	
	for key in spells:
		var cd = spells[key].cd
		var p = cd.time_left / cd.get_wait_time()
		progress[key] = p

	cd_update.emit(progress)
	
	
func play_spell_sound(spell_name):
	var key = "Sound " + spell_name
	if key in sounds:
		sounds[key].play()


func update_hp_regen_cd():
	var speed_factor = 100.0 / speed
	
	var new_heal_cd = speed_factor * hp_regen_cd
	hp_regen.set_wait_time(new_heal_cd)


func _on_hit_point_regeneration_timeout():
	update_hp(hp_regen_value)
