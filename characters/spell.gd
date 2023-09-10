extends Node

class_name Spell

@export var damage = 100
@export var cd_original = 1.5
@export var rp_gain = 10
@export var hp_gain = 0
@export var can_speed_up = true		# if the cooldown is hasted from wow

var cd: Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	cd = $CDProgress
	cd.set_wait_time(cd_original)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
