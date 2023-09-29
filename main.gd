extends Control

var game_paused = false
var in_game = false

var current_boss: String

func _ready():
	init_signals()


func _input(event):
	if in_game:
		if event.is_action_pressed("ui_cancel"):
			if game_paused:
				$PauseMenu.visible = false
				$Gameplay.unpause_game()
			else:
				$PauseMenu.visible = true
				$Gameplay.pause_game()
			game_paused = !game_paused


func _start_game(boss_name: String):
	current_boss = boss_name
	in_game = true
	game_paused = false
	$Gameplay.unpause_game()
	$Gameplay.start_game(boss_name)
	set_ui_visibility(false, true, false, false)


func _continue_game():
	game_paused = false
	$Gameplay.unpause_game()
	set_ui_visibility(false, true, false, false)

func _quit():
	get_tree().quit()


func _quit_to_title():
	in_game = false
	game_paused = false
	set_ui_visibility(false, false, false, true)
	
func _restart_game():
	_start_game(current_boss)


func init_signals():
	$TitleMenu.start_game.connect(_start_game)
	$TitleMenu.quit.connect(_quit)
	
	$PauseMenu.continue_game.connect(_continue_game)
	$PauseMenu.quit.connect(_quit)
	$PauseMenu.quit_to_title.connect(_quit_to_title)
	$PauseMenu.restart_game.connect(_restart_game)


func set_ui_visibility(end: bool, hud: bool, pause: bool, title: bool):
	$EndScreen.visible = end
	$HUD.visible = hud
	$PauseMenu.visible = pause
	$TitleMenu.visible = title
