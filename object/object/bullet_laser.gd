extends "res://object/bullet_normal.gd"

func _ready():
	hp = 3
	type = 2
	SfxController.play_laser()
