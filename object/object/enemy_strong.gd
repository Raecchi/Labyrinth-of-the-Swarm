extends "res://object/enemy_common.gd"

func _ready():
	hp = 3
	speed = 50
	call_deferred("_find_player")
