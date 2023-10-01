extends Control

var game_paused: bool
var in_game: bool

var current_boss: String
var game_music_position

func _ready():
	init_signals()
	# the game will start in title menu
	_quit_to_title()

func _input(event):
	if in_game:
		if event.is_action_pressed("ui_cancel"):
			if game_paused:
				_continue_game()
			else:
				_pause_game()


func _start_game(boss_name: String):
	# TODO here save save the music path in boss and retrieve it here
	Music.load_and_play("res://assets/arena_space_music.mp3")
	current_boss = boss_name
	in_game = true
	game_paused = false
	$Gameplay.unpause_game()
	$Gameplay.start_game(boss_name)
	set_ui_visibility(false, true, false, false)
	
func _start_random_game():
	pass
	# todo


func _continue_game():
	game_paused = false
	$Gameplay.unpause_game()
	Music.load_and_play("res://assets/arena_space_music.mp3", game_music_position)
	set_ui_visibility(false, true, false, false)
	
func _pause_game():
	game_music_position = Music.get_playback_position()
	
	game_paused = true
	$Gameplay.pause_game()
	Music.load_and_play("res://assets/menu_pause.mp3")
	set_ui_visibility(false, true, true, false)


func _game_over():
	in_game = false
	game_paused = true
	$Gameplay.pause_game()
	set_ui_visibility(true, false, false, false)

func _game_victory():
	_game_over()
	$EndScreen.set_title("VICTORY")


func _game_defeat():
	_game_over()
	$EndScreen.set_title("DEFEAT")


func _quit():
	get_tree().quit()


func _quit_to_title():
	in_game = false
	game_paused = false	
	Music.load_and_play("res://assets/menu_main.mp3", 1.5)
	set_ui_visibility(false, false, false, true)
	
func _restart_game():
	_start_game(current_boss)


func init_signals():
	$Gameplay.game_victory.connect(_game_victory)
	$Gameplay.game_defeat.connect(_game_defeat)
	
	$TitleMenu.start_game.connect(_start_game)
	$TitleMenu.quit.connect(_quit)
	
	$PauseMenu.continue_game.connect(_continue_game)
	$PauseMenu.quit.connect(_quit)
	$PauseMenu.quit_to_title.connect(_quit_to_title)
	$PauseMenu.restart_game.connect(_restart_game)
	
	$EndScreen.quit_to_title.connect(_quit_to_title)
	$EndScreen.start_random_game.connect(_start_random_game)
	$EndScreen.restart_game.connect(_restart_game)


func set_ui_visibility(end: bool, hud: bool, pause: bool, title: bool):
	$EndScreen.visible = end
	$HUD.visible = hud
	$PauseMenu.visible = pause
	$TitleMenu.visible = title
