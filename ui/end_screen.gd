extends Control

signal quit_to_title
signal restart_game
signal start_random_game

var buttons: Node

func _ready():
	init_signals()


func set_title(s: String):
	$C/P/Label.set_text(s)


func _on_quit_to_title_button_pressed():
	quit_to_title.emit()


func _on_start_random_game_button_pressed():
	start_random_game.emit()


func _on_restart_game_button_pressed():
	restart_game.emit()


func _refocus():
	$C/P/P/VB/RedoCurrentEncounterButton.grab_focus()


func init_signals():
	$C/P/P/VB/QuitToTitleButton.pressed.connect(_on_quit_to_title_button_pressed)
	$C/P/P/VB/RandomEncounterButton.pressed.connect(_on_start_random_game_button_pressed)
	$C/P/P/VB/RedoCurrentEncounterButton.pressed.connect(_on_restart_game_button_pressed)
	visibility_changed.connect(_refocus)
