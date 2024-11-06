extends "res://scripts/character_script.gd"

const POWERUP_SHOTGUN = preload("res://object/powerup_shotgun.tscn")
const POWERUP_BUBBLE = preload("res://object/power_up_bubble.tscn")
const POWERUP_EXPLOSIVE = preload("res://object/power_up_explosive.tscn")
const POWERUP_INVINCIBLE = preload("res://object/power_up_invincible.tscn")
const POWERUP_LASER = preload("res://object/power_up_laser.tscn")
const POWERUP_SPEED = preload("res://object/power_up_speed.tscn")

@export var score = 0
var player_id = 0

var randomNum = 0
var rng = RandomNumberGenerator.new()

var target

func scoring():
	match player_id:
		1:
			GameData.set_player_1_score(GameData.get_player_1_score() + score)
			GameData.set_player_1_life_up_score(GameData.get_player_1_life_up_score() + score)
		2:
			GameData.set_player_2_score(GameData.get_player_2_score() + score)
			GameData.set_player_2_life_up_score(GameData.get_player_2_life_up_score() + score)

func boss_scoring():
	GameData.set_player_1_score(GameData.get_player_1_score() + score)
	GameData.set_player_1_life_up_score(GameData.get_player_1_life_up_score() + score)
	
	if GameData.get_game_mode() == 2:
		GameData.set_player_2_score(GameData.get_player_2_score() + score)
		GameData.set_player_2_life_up_score(GameData.get_player_2_life_up_score() + score)

func is_range(range_mode):
	if range_mode:
		return true
	else:
		return false

func _find_player():
	if GameData.get_game_mode() == 1:
		target = get_node("/root/player_test")
		if !target:
			print("Not Found")
	else:
		randomNum = rng.randi_range(1,2)
		match randomNum:
			1:
				target = get_node("/root/player_test")
			2:
				target = get_node("/root/player_2")
		

func switch_target():
	target = get_node("/root/player_test")
	if !target:
		target = get_node("/root/player_2")
	

func drop_power():
	rng.randomize()
	var item_drop = 0.03
	if rng.randf() < item_drop:
		var item
		randomNum = rng.randi_range(1,6)
		match randomNum:
			1:
				item = POWERUP_LASER.instantiate()
			2:
				item = POWERUP_SHOTGUN.instantiate()
			3:
				item = POWERUP_EXPLOSIVE.instantiate()
			4:
				item = POWERUP_BUBBLE.instantiate()
			5:
				item = POWERUP_SPEED.instantiate()
			6:
				item = POWERUP_INVINCIBLE.instantiate()
		item.position = global_position
		get_parent().add_child(item)
