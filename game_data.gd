extends Node

var player_1_hp = 5
var player_1_ammo = 0
var player_1_score = 0
var player_1_life_up_score = 0
var player_1_gun_type = 0
var player_1_bubble = false
var player_1_shotgun = false

var player_2_hp = 0
var player_2_ammo = 0
var player_2_score = 0
var player_2_life_up_score = 0
var player_2_gun_type = 0
var player_2_bubble = false
var player_2_shotgun = false

var total_player_deaths = 0

var game_mode = 1
var stage = 1
var room = 1
var total_rooms = 0
var number_of_enemies = 30
var enemies_dead = 0
var room_clear = false
var player_spawn_direction = 0

var boss_4_arm_amount = 1
var boss_4_arm_disappear = 0

func _physics_process(delta):
	
	if player_1_life_up_score >= 3000:
		SfxController.play_life_up()
		player_1_hp += 1
		player_1_life_up_score -= 3000
	if player_2_life_up_score >= 3000:
		SfxController.play_life_up()
		player_2_hp += 1
		player_2_life_up_score -= 3000
	
	if number_of_enemies <= enemies_dead and room != 5:
		room_clear = true
	


func get_player_1_hp():
	return player_1_hp

func get_player_2_hp():
	return player_2_hp

func set_player_1_hp(hp):
	player_1_hp = hp

func set_player_2_hp(hp):
	player_2_hp = hp

func get_player_1_ammo():
	return player_1_ammo

func get_player_2_ammo():
	return player_2_ammo

func set_player_1_ammo(number):
	player_1_ammo = number

func set_player_2_ammo(number):
	player_2_ammo = number

func get_player_1_score():
	return player_1_score

func get_player_2_score():
	return player_2_score

func set_player_1_score(score):
	player_1_score = score

func set_player_2_score(score):
	player_2_score = score

func get_player_1_gun_type():
	return player_1_gun_type

func get_player_2_gun_type():
	return player_2_gun_type

func set_player_1_gun_type(type):
	player_1_gun_type = type

func set_player_2_gun_type(type):
	player_2_gun_type = type

func get_player_1_life_up_score():
	return player_1_life_up_score

func get_player_2_life_up_score():
	return player_2_life_up_score

func set_player_1_life_up_score(score):
	player_1_life_up_score = score

func set_player_2_life_up_score(score):
	player_2_life_up_score = score

func get_player_1_bubble():
	return player_1_bubble

func get_player_2_bubble():
	return player_2_bubble

func set_player_1_bubble(bubble):
	player_1_bubble = bubble

func set_player_2_bubble(bubble):
	player_2_bubble = bubble

func get_player_1_shotgun():
	return player_1_shotgun

func get_player_2_shotgun():
	return player_2_shotgun

func set_player_1_shotgun(shotgun):
	player_1_shotgun = shotgun

func set_player_2_shotgun(shotgun):
	player_2_shotgun = shotgun

func get_boss_4_arm_amount():
	return boss_4_arm_amount

func get_boss_4_arm_disappear():
	return boss_4_arm_disappear

func set_boss_4_arm_amount(number):
	boss_4_arm_amount += number

func set_boss_4_arm_disappear(number):
	boss_4_arm_disappear += 1

func reset_boss_4_arm_disappear():
	boss_4_arm_disappear = 0

func get_game_mode():
	return game_mode

func set_game_mode(number):
	game_mode = number

func get_stage():
	return stage

func get_room():
	return room

func get_total_rooms():
	return total_rooms

func set_stage(number):
	stage = number

func set_room(number):
	room = number

func set_total_rooms(number):
	total_rooms = number

func get_number_of_enemies():
	return number_of_enemies

func set_number_of_enemies(number):
	number_of_enemies = number

func get_enemies_dead():
	return enemies_dead

func set_enemies_dead(number):
	enemies_dead = number

func get_room_clear():
	return room_clear

func set_room_clear(condition):
	room_clear = condition

func get_player_spawn_direction():
	return player_spawn_direction

func set_player_spawn_direction(direction):
	player_spawn_direction = direction

func get_total_player_deaths():
	return total_player_deaths

func set_total_player_deaths(number):
	total_player_deaths = number
	game_over_check()

func game_over_check():
	var dynamic_objects = get_tree().get_nodes_in_group("dynamic")
	if game_mode == 1 and total_player_deaths == 1:
		MusicController.stop()
		for obj in dynamic_objects:
			obj.queue_free()
		get_tree().change_scene_to_file("res://map/main_menu.tscn")
	else:
		if total_player_deaths == 2:
			MusicController.stop()
			for obj in dynamic_objects:
				obj.queue_free()
			get_tree().change_scene_to_file("res://map/main_menu.tscn")


func reset_total_player_deaths():
	total_player_deaths = 0
