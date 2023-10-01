extends Control

signal quit
signal continue_game
signal restart_game
signal quit_to_title

var buttons: Node

func _ready():
	init_signals()

func _on_continue_game_button_pressed():
	continue_game.emit()


func _on_exit_game_button_pressed():
	quit.emit()


func _on_quit_to_title_button_pressed():
	quit_to_title.emit()


func _on_restart_game_button_pressed():
	restart_game.emit()


func _refocus():
	$OptionsPanel/CountinueGameButton.grab_focus()


func init_signals():
	$OptionsPanel/CountinueGameButton.pressed.connect(_on_continue_game_button_pressed)
	$OptionsPanel/QuitToTitleButton.pressed.connect(_on_quit_to_title_button_pressed)
	$OptionsPanel/ExitGameButton.pressed.connect(_on_exit_game_button_pressed)
	$OptionsPanel/RestartGameButton.pressed.connect(_on_restart_game_button_pressed)
	visibility_changed.connect(_refocus)

