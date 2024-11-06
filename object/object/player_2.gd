extends "res://object/player_test.gd"

func _ready():
	player_id = 2
	speed = 80
	
	hp = GameData.get_player_2_hp()
	bullet_counter = GameData.get_player_2_ammo()
	bullet_type = GameData.get_player_2_gun_type()
	shotgun = GameData.get_player_2_shotgun()
	
	if GameData.get_player_2_bubble():
		turn_on_powerup(1)
