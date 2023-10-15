extends Arena



# Called when the node enters the scene tree for the first time.
func _ready():
	GAME_POSITION_MIN = Vector2(1,1)
	GAME_POSITION_MAX = Vector2(2,1)
	BOSS_POSITION = Vector2(900,550)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
