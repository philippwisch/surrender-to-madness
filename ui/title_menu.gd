extends Control

signal start_game
signal quit

var bosses = []
var boss_vbox
var main_vbox

# Called when the node enters the scene tree for the first time.
func _ready():
	create_boss_buttons()
	init_signals()
	
	$OptionsPanel/Main/StartButton.grab_focus()


func create_boss_buttons():
	var boss_names = load_boss_names()
	for boss_name in boss_names:
		var button = Button.new()
		# convert the boss's name from "snake_case" to "Title Case"
		button.set_text(boss_name.capitalize())
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.pressed.connect(
			func():
				start_game.emit(boss_name)
		)
		$OptionsPanel/Bosses.add_child(button)
		$OptionsPanel/Bosses.move_child(button, 0)


func load_boss_names():
	var boss_names = []
	var dir = DirAccess.open("res://gameplay/bosses/")
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		# check if it is a scene by looking at the file ending
		var split_string = file_name.split(".")
		var file_start = split_string[0]
		var file_end = split_string[1]
		
		if file_end == "tscn":
			boss_names.append(file_start)
		file_name = dir.get_next()
	return boss_names


func _on_start_button_pressed():
	$OptionsPanel/Main.visible = false
	$OptionsPanel/Bosses.visible = true
	# for now: Just select the first button
	# would be better to save the last boss the player
	# selected though, so you don't have to select it everytime
	# if you're trying to beat a boss over and over
	$OptionsPanel/Bosses.get_children()[0].grab_focus()


func _on_quit_game_button_pressed():
	quit.emit()


func _on_back_button_pressed():
	_refocus()


func _refocus():
	$OptionsPanel/Main.visible = true
	$OptionsPanel/Bosses.visible = false
	$OptionsPanel/Main/StartButton.grab_focus()

func init_signals():
	$OptionsPanel/Main/StartButton.pressed.connect(_on_start_button_pressed)
	$OptionsPanel/Main/QuitGameButton.pressed.connect(_on_quit_game_button_pressed)
	visibility_changed.connect(_refocus)
	
	var boss_buttons = $OptionsPanel/Bosses.get_children()
	for button in boss_buttons:
		var back = $OptionsPanel/Bosses/BackButton
		if button == back:
			back.pressed.connect(_on_back_button_pressed)
