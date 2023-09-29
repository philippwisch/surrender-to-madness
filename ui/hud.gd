extends Control

@export var gameplay: Gameplay

var hp
var rp
var cast
var icons

var boss_hp
var boss_cast

# Called when the node enters the scene tree for the first time.
func _ready():
	init_signals()


	hp = get_node("Hp")
	rp = get_node("Rp")
	cast = get_node("Cast")
	boss_hp = get_node("BossHp")
	boss_cast = get_node("BossCast")

	icons = {
		# Dennis fragen: Würde lieber const als inline string literals benutzen
		# aber ich will auch zugriff darauf haben in zb player!
		# autoload?
		"Mind Flay": $Cast/CD1,
		"Void Bolt": $Cast/CD2,
		"Mind Blast": $Cast/CD3,
		"Shadow Word Death": $Cast/CD4,
		"Shadow Mend": $Cast/CDSmall1,
		"Silence": $Cast/CDSmall2,
	}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_countdown(time):
	$Countdown.set_text(time)


func _on_boss_cast_finished():
	boss_cast.value = 0
	$BossCast/CastText.set_text("")


func _on_boss_cast_update(new_val, new_text):
	boss_cast.value = 100 - new_val * 100
	$BossCast/CastText.set_text(new_text)


func _on_boss_hp_update(new_val):
	boss_hp.value = new_val * 100


func _on_player_cast_finished():
	cast.value = 0
	$Cast/CastText.set_text("")


func _on_player_cast_update(new_val, new_text):
	cast.value = 100 - new_val * 100
	$Cast/CastText.set_text(new_text)


func _on_player_cd_update(progress):
	for key in progress:
		if key in icons:
			var new_val = 100 - progress[key] * 100
			icons[key].value = new_val

# TODO
func _on_player_death():
# Maybe fade out screen
# Player Death Animation?
	$Sprite2D.visible = true
	pass


func _on_player_hp_update(new_val):
	hp.value = new_val * 100


func _on_player_rp_update(new_val):
	rp.value = new_val * 100


func _on_player_speed_update(new_val):
	if new_val == 100:
		$Speed.set_text("")
	else:
		$Speed.set_text("SPEED: +" + str(max(0, new_val - 100)) + "%!")


func init_signals():
	gameplay.countdown.connect(_on_countdown)
	
	gameplay.boss_cast_finished.connect(_on_boss_cast_finished)
	gameplay.boss_cast_update.connect(_on_boss_cast_update)
	gameplay.boss_hp_update.connect(_on_boss_hp_update)

	gameplay.player_cast_finished.connect(_on_player_cast_finished)
	gameplay.player_cast_update.connect(_on_player_cast_update)
	gameplay.player_cd_update.connect(_on_player_cd_update)
	gameplay.player_death.connect(_on_player_death)
	gameplay.player_hp_update.connect(_on_player_hp_update)
	gameplay.player_rp_update.connect(_on_player_rp_update)
	gameplay.player_speed_update.connect(_on_player_speed_update)
	

