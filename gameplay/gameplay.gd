extends Node2D

class_name Gameplay

signal player_cast_update
signal player_cd_update
signal player_hp_update
signal player_rp_update
signal player_speed_update
signal player_death

signal boss_hp_update
signal boss_cast_update
signal boss_death

var player
var boss: Boss

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $Player
	boss = $Boss


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	



func _on_player_cast_update(cast_progress, cast_name):
	player_cast_update.emit(cast_progress, cast_name)


func _on_player_cd_update(progress):
	player_cd_update.emit(progress)


func _on_player_death():
	player_death.emit()


func _on_player_hp_update(hp):
	player_hp_update.emit(hp)


func _on_player_rp_update(rp):
	player_rp_update.emit(rp)


func _on_player_speed_update(speed):
	player_speed_update.emit(speed)


func _on_player_cast_finished(damage):
	boss.hp -= damage
	boss_hp_update.emit(float(boss.hp) / float(boss.hp_max))
