extends Node2D

var game_paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	start_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if game_paused:
			$Gameplay.unpause_game()
		else:
			$Gameplay.pause_game()
		game_paused = !game_paused
	
func start_game():
	$Gameplay.start_game("dummy","dummy")
	# stop main menu music
