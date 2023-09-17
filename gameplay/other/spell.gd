extends Node

class_name Spell

@export var damage = 100
@export var cd_original = 1.5
@export var cast_original = 1.5
@export var rp_gain = 0
@export var hp_gain = 0
@export var can_speed_up = true		# if the cooldown is hasted (like wow)
	

# Global Cooldown, period of time after the spell in which
# no other spell can be cast
# useful for boss abilities that have a wind-down animation
@export var global_cooldown = 1.5
# used to determine which spell the boss will use next
@export var priority = 0

signal cast_finished
signal cd_finished
signal gcd_finished

var cast: Timer
var cd: Timer
var gcd: Timer

var cast_just_finished = true
var cd_ready = true
var gcd_ready = true


# Called when the node enters the scene tree for the first time.
func _ready():
	cast = $CastProgress
	cast.set_wait_time(cast_original)
	
	cd = $CDProgress
	cd.set_wait_time(cd_original)
	
	gcd = $GCDProgress
	gcd.set_wait_time(global_cooldown)	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func start_timers():
	cast.start()
	cd.start()
	gcd.start()
	cast_just_finished = false
	cd_ready = false
	gcd_ready = false	

func _on_cast_progress_timeout():
	cast_finished.emit()
	cast_just_finished = true


func _on_cd_progress_timeout():
	cd_finished.emit()
	cd_ready = true


func _on_gcd_progress_timeout():
	gcd_finished.emit()
	gcd_ready = true
