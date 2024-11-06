extends CanvasLayer

func _physics_process(delta):
	#player_1
	$player_1/hp.text = str(GameData.get_player_1_hp())
	$player_1/score.text = str(GameData.get_player_1_score())
	if GameData.get_player_1_ammo() == 0:
		$player_1/ammo.text = "INF"
	else:
		$player_1/ammo.text = str(GameData.get_player_1_ammo())
	
	#player_2
	$player_2/hp.text = str(GameData.get_player_2_hp())
	$player_2/score.text = str(GameData.get_player_2_score())
	if GameData.get_player_2_ammo() == 0:
		$player_2/ammo.text = "INF"
	else:
		$player_2/ammo.text = str(GameData.get_player_2_ammo())
