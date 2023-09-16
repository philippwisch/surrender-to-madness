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
	gameplay.player_cast_update.connect(_on_player_cast_update)
	gameplay.player_cd_update.connect(_on_player_cd_update)
	gameplay.player_hp_update.connect(_on_player_hp_update)
	gameplay.player_rp_update.connect(_on_player_rp_update)
	gameplay.player_speed_update.connect(_on_player_speed_update)
	gameplay.player_death.connect(_on_player_death)
	
	gameplay.boss_hp_update.connect(_on_boss_hp_update)
	gameplay.boss_cast_update.connect(_on_boss_cast_update)
	
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

func _on_player_hp_update(new_val):
	hp.value = new_val


func _on_player_rp_update(new_val):
	rp.value = new_val


func _on_player_cast_update(new_val, new_text):
	if new_val == 0:
		cast.value = 0
		$Cast/CastText.set_text("")
	else:
		cast.value = 100 - new_val * 100
		$Cast/CastText.set_text(new_text)


func _on_player_cd_update(progress):
	for key in progress:
		if key in icons:
			var new_val = 100 - progress[key] * 100
			icons[key].value = new_val


func _on_player_speed_update(new_val):
	$Speed.set_text("SPEED: +" + str(max(0, new_val - 100)) + "%!")

# TODO
# Maybe fade out screen
# Player Death Animation?
func _on_player_death():
	pass


func _on_boss_hp_update(new_val):
	boss_hp.value = new_val * 100


func _on_boss_cast_update(new_val, new_text):
	if new_val == 0:
		cast.value = 0
		$BossCast/CastText.set_text("")
	else:
		cast.value = 100 - new_val * 100
		$BossCast/CastText.set_text(new_text)
