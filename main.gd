extends Control

var game_paused = false

func _ready():
	init_signals()
	#start_game()


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if game_paused:
			$Gameplay.unpause_game()
		else:
			$Gameplay.pause_game()
		game_paused = !game_paused


func _on_title_menu_boss_selected(boss_name: String):
	$Gameplay.start_game(boss_name)
	$TitleMenu.visible = false


func init_signals():
	$TitleMenu.start_game.connect(_on_title_menu_boss_selected)
