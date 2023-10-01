extends Control

class_name Menu


func _ready():
	init_signals()


func _on_visibility_changed():
	get_children()
	
func init_signals():
	visibility_changed.connect(_on_visibility_changed)
