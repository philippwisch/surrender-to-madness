extends Sprite2D

func _ready():
	init_signals()

func _on_timer_timeout():
	var brightness = randf_range(0.8,1.2)
	var r = int(brightness * 77)
	var g = int(brightness * 20)
	var b = int(brightness * 111)
	modulate = Color8(r,g,b)

func init_signals():
	$Timer.timeout.connect(_on_timer_timeout)
	pass
