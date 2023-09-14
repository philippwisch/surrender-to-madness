extends Node2D

signal game_start

# Called when the node enters the scene tree for the first time.
func _ready():
	game_start.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		$Menu.visible = !$Menu.visible
