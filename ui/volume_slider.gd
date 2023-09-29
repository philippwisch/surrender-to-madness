extends HSlider


@export var audio_bus_name = "Master"

@onready var _bus = AudioServer.get_bus_index(audio_bus_name)


func _ready():
	value_changed.connect(_on_value_changed)
	AudioServer.bus_layout_changed.connect(_on_audio_bus_bus_layout_changed)
	# todo load from userpref.ini
	
	# this line is now obsolete
	value = db_to_linear(AudioServer.get_bus_volume_db(_bus))


func _on_value_changed(new_value: float):
	AudioServer.set_bus_volume_db(_bus, linear_to_db(new_value))
	
	# I ran into a problem here because I use this VolumeSlider in both the
	# pause menu as well as the title menu. If the user moves one slider
	# (for example music in title), this method will correctly update
	# the volume property on the audio bus that is assigned to the slider instance
	# (in this project there are two buses: effects and music),
	# but the other slider (for example music in pause menu) will not be updated,
	# and still display the old, now incorrect value.
	# This happens because the two sliders in pause menu and title menu are
	# different instances of this VolumeSlider.
	# If only using the line above this comment there basically is only
	# one-way data-binding from the ui layer to the logic layer.
	#
	# to fix this issue and provide two-way data-binding, the global AudioServer's
	# Signal bus_layout_changed is triggered. Documentation on bus_layout is rather
	# sparse but it seems like a change in volume should probably trigger this signal
	# but does not, so I just do it manually in the following line:
	AudioServer.bus_layout_changed.emit()

func _on_audio_bus_bus_layout_changed():
	value = db_to_linear(AudioServer.get_bus_volume_db(_bus))
