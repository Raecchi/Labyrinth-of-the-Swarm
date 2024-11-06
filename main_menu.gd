extends Node2D

var game_mode = 1
var timer = 0
var blink_time = 0
var game_start = false
var credits = false

func _ready():
	game_mode = 1
	GameData.set_game_mode(game_mode)

func _physics_process(delta):
	match game_mode:
		1:
			$PRESS_START/Arrow.visible = true
			$PRESS_START/Arrow2.visible = false
			$PRESS_START/Arrow3.visible = false
		2:
			$PRESS_START/Arrow.visible = false
			$PRESS_START/Arrow2.visible = true
			$PRESS_START/Arrow3.visible = false
		3:
			$PRESS_START/Arrow.visible = false
			$PRESS_START/Arrow2.visible = false
			$PRESS_START/Arrow3.visible = true
	
	if (Input.is_action_just_pressed("p1_select") or Input.is_action_just_pressed("p2_select")) and !credits:
		game_mode += 1
		#GameData.set_game_mode(game_mode)
		SfxController.play_switch()
		if game_mode == 4:
			game_mode = 1
		#print("pressed")
	
	if (Input.is_action_just_pressed("p1_start") or Input.is_action_just_pressed("p2_start")) and !credits and !game_start:
		match game_mode:
			1:
				GameData.set_game_mode(1)
				GameData.set_player_1_hp(10)
				GameData.set_player_2_hp(0)
				
			2:
				GameData.set_game_mode(2)
				GameData.set_player_1_hp(10)
				GameData.set_player_2_hp(10)
		
		if game_mode != 3:
			GameData.set_player_1_score(0)
			GameData.set_player_1_life_up_score(0)
			GameData.set_player_2_score(0)
			GameData.set_player_2_life_up_score(0)
			GameData.set_player_1_ammo(0)
			GameData.set_player_1_gun_type(0)
			GameData.set_player_2_ammo(0)
			GameData.set_player_2_gun_type(0)
			GameData.set_player_spawn_direction(0)
			
			GameData.set_stage(1)
			GameData.set_room(1)
			GameData.set_total_rooms(1)
			GameData.set_number_of_enemies(30)
		
		SfxController.play_select()
		game_start = true
		
	
	if game_start:
		timer += 1
		#print(timer)
		blink_time += 1
		if blink_time % 2 == 0:
			match game_mode:
				1:
					$PRESS_START/Player_1.visible = not $PRESS_START/Player_1.visible 
				2:
					$PRESS_START/Player_2.visible = not $PRESS_START/Player_2.visible
				3:
					$PRESS_START/Credits.visible = not $PRESS_START/Credits.visible
		
		if timer == 60:
			if game_mode != 3:
				get_tree().change_scene_to_file("res://map/arena.tscn")
			else:
				game_start = false
				$Credits.visible = true
				credits = true
	
	if ((Input.is_action_just_pressed("p1_start") or Input.is_action_just_pressed("p2_start")) or (Input.is_action_just_pressed("p1_select") or Input.is_action_just_pressed("p2_select"))) and credits:
		$Credits.visible = false
		credits = false
		game_start = false
		timer = 0
