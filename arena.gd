extends Node2D

const PLAYER_1_PATH = preload("res://object/player_test.tscn")
const PLAYER_2_PATH = preload("res://object/player_2.tscn")

const ENEMY_COMMON_PATH = preload("res://object/enemy_common.tscn")
const ENEMY_STRONG_PATH = preload("res://object/enemy_strong.tscn")
const ENEMY_RANGE_PATH = preload("res://object/enemy_range.tscn")
const BOSS_1_PATH = preload("res://object/boss_1.tscn")
const BOSS_2_PATH = preload("res://object/boss_2.tscn")
const BOSS_3_PATH = preload("res://object/boss_3.tscn")
const BOSS_4_PATH = preload("res://object/boss_4.tscn")


var timer = 0
var enemy_spawn_timer = 0
var enemy_spawn_number = 0

var stop = false
var stop_timer = 0

var stage = GameData.get_stage()
var room = GameData.get_room()

#var player_spawn = 0

var temp_enemy_counter = 0
var rng = RandomNumberGenerator.new()
var rng_side = 0
var rng_enemy = 0
#This is for spawning the range enemy.
var grid_size = 8
var spawn_areas = []
var boss_round = true
var moving = false
var once = false

#This is to define the types of enemies with they likelyhood to spawn, depending on how far you are in.
var base_enemy_types = [{"scene": ENEMY_COMMON_PATH, "spawn_weight": 100},
						{"scene": ENEMY_RANGE_PATH, "spawn_weight": 0},
						{"scene": ENEMY_STRONG_PATH, "spawn_weight": 0}]

#This the current enemy types that are in depending on the number of rooms passed.
var enemy_types = []

func _ready():
	spawn_players()
	enemy_spawn_number = GameData.get_number_of_enemies()
	define_spawn_area()
	enemy_types = base_enemy_types.duplicate(true) #Starts with the base a
	adjust_enemy_weights()
	print ("Common enemy spawn rate: %d%%" % enemy_types[0]["spawn_weight"])
	print ("Range enemy spawn rate: %d%%" % enemy_types[1]["spawn_weight"])
	print ("Strong enemy spawn rate: %d%%" % enemy_types[2]["spawn_weight"])
	change_map()
	GameData.set_enemies_dead(0)
	GameData.set_room_clear(false)
	change_music()
	temp_enemy_counter = 0
	stop = false
	stop_timer = 0
	GameData.reset_total_player_deaths()
	
	if GameData.get_total_rooms() == 1:
		$map/text.visible = true
		if GameData.get_game_mode() == 2:
			$map/text/p2.visible = true
	
	if GameData.get_game_mode() == 2:
		if GameData.get_player_1_hp() <= 0:
			GameData.set_player_1_hp(5)
		elif GameData.get_player_2_hp() <= 0:
			GameData.set_player_2_hp(5)
	

func _physics_process(delta):
	if enemy_spawn_number > 0:
		if timer != 120:
			timer += 1
			#print(timer)
		else:
			spawn_enemy()
	if GameData.get_room_clear() and !once:
		MusicController.play_calm()
		open_gates()
		once = true 
	
	if moving:
		camera_move()
	
	if stop:
		stop_timer += 1
		if stop_timer == 30:
			if get_node("/root/player_test"):
				get_node("/root/player_test").queue_free()
			elif get_node("/root/player_2"):
				get_node("/root/player_2").queue_free()
			delete_leftover()
			get_tree().reload_current_scene()


func define_spawn_area():
	#This is to get the top left corners of each region. 
	var top_left_corners = [Vector2(48,48), Vector2(160,48), Vector2(48,144), Vector2(160,144)]
	
	#A nested triple for loop to create all the boxes in each region.
	for region in top_left_corners:
		for x in range(6):
			for y in range(6):
				spawn_areas.append(Rect2(region + Vector2(x,y) * grid_size, Vector2(grid_size, grid_size)))
				

func spawn_enemy():
	if enemy_spawn_timer < 20:
		#print("enemy spawning timer: ", enemy_spawn_timer)
		enemy_spawn_timer += 1
	else:
		if room != 5:
			#rng_enemy = rng.randi_range(1,3)
			#adjust_enemy_weights()
			var enemy = select_random_enemy()
			#Previous enemy_spawn algorithm.
			#match rng_enemy:
				#1:
					#enemy = ENEMY_COMMON_PATH.instantiate()
					#spawn_non_range_enemy(enemy)
				#2:
					#enemy = ENEMY_RANGE_PATH.instantiate()
					#spawn_range_enemy(enemy)
				#3:
					#enemy = ENEMY_STRONG_PATH.instantiate()
					#spawn_non_range_enemy(enemy)
			if enemy:
				#print(enemy)
				if temp_enemy_counter <= 0:
					temp_enemy_counter = 5
					rng_side = rng.randi_range(1,4)
				if enemy.is_range(enemy.range_mode):
					spawn_range_enemy(enemy)
				else:
					spawn_non_range_enemy(enemy)
			enemy_spawn_number -= 1
			enemy_spawn_timer = 0
			print("Enemies left: ", enemy_spawn_number)
			temp_enemy_counter -= 1
		else:
			if boss_round:
				spawn_boss()

func spawn_range_enemy(enemy):
	#Picks a random box, finds the position of the random box, and puts the enemy's position there.
	var area = spawn_areas[rng.randi_range(0,spawn_areas.size() - 1)]
	var random_position = Vector2(rng.randf_range(area.position.x, area.position.x + area.size.x),
								  rng.randf_range(area.position.y, area.position.y + area.size.y))
	
	enemy.position = random_position
	get_parent().add_child(enemy)

func spawn_non_range_enemy(enemy):
	#rng_side = rng.randi_range(1,4)
	
	match rng_side:
		1:
			enemy.position = $enemy_spawn/spawner_north.global_position
		2:
			enemy.position = $enemy_spawn/spawner_east.global_position
		3:
			enemy.position = $enemy_spawn/spawner_south.global_position
		4:
			enemy.position = $enemy_spawn/spawner_west.global_position
	
	get_parent().add_child(enemy)

#To adjust the likelyhood of the enemy types to appear as how many rooms has passed
#As the other rates increases, common decreases.
func adjust_enemy_weights():
	#Start spawning range from room 3, and it gradually increases the rate to the max of 30%.
	if GameData.get_total_rooms() >= 3:
		enemy_types[1]["spawn_weight"] = min(10 + (GameData.get_total_rooms() - 3) * 2.5, 30)
		enemy_types[0]["spawn_weight"] -= (enemy_types[1]["spawn_weight"] - 0)
	
	#Start spawning strong from room 5, and it gradually increases the rate to the max of 30%
	if GameData.get_total_rooms() >= 5:
		enemy_types[2]["spawn_weight"] = min(6 + (GameData.get_total_rooms() - 5) * 2.5, 30)
		enemy_types[0]["spawn_weight"] -= (enemy_types[2]["spawn_weight"] - 0)
	
	#The ideal max of the rate is 40%/30%/30%.
	
	#In case the total % of all spawn rate combined exceeds 100%
	var total_weight = 0
	for type in enemy_types:
		print("Pre-patch: %d%%" % type["spawn_weight"])
		total_weight += type["spawn_weight"]
	
	if total_weight > 100:
		for type in enemy_types:
			type["spawn_weight"] = int(type["spawn_weight"] * 100 / total_weight)
	
	#Previous version
	#for type in enemy_types:
		#if type["scene"] == ENEMY_COMMON_PATH:
			#type["spawn_weight"] = max(10,50 - GameData.get_total_rooms() * 2)
		#elif type["scene"] == ENEMY_RANGE_PATH:
			#type["spawn_weight"] = 30 + GameData.get_total_rooms() * 1.5
		#elif type["scene"] == ENEMY_STRONG_PATH:
			#type["spawn_weight"] = 20 + GameData.get_total_rooms() * 1

#Select from the types of enemies from the current pool of types.
func select_random_enemy():
	var total_weight = 0
	for type in enemy_types:
		total_weight += type["spawn_weight"]
	
	var random_number = rng.randi_range(0, total_weight - 1)
	
	var accumulated_weight = 0
	
	for type in enemy_types:
		accumulated_weight += type["spawn_weight"]
		if random_number < accumulated_weight:
			return type["scene"].instantiate()
	return null

#Spawn boss when it's boss room
func spawn_boss():
	var enemy
	match stage:
		1:
			enemy = BOSS_1_PATH.instantiate()
		2:
			enemy = BOSS_2_PATH.instantiate()
		3:
			enemy = BOSS_3_PATH.instantiate()
		4:
			enemy = BOSS_4_PATH.instantiate()
	enemy.position = $enemy_spawn/boss_spawner.global_position
	get_parent().add_child(enemy)
	boss_round = false


func camera_move():
	match GameData.get_player_spawn_direction():
		1:
			$Camera2D.limit_bottom -= 2
			$Camera2D.limit_top -= 2
			if $Camera2D.limit_bottom == 0:
				moving = false
				stop = true
		2:
			$Camera2D.limit_right += 2
			$Camera2D.limit_left += 2
			if $Camera2D.limit_left == 256:
				moving = false
				stop = true
		3:
			$Camera2D.limit_top += 2
			$Camera2D.limit_bottom += 2
			if $Camera2D.limit_top == 240:
				moving = false
				stop = true
		4:
			$Camera2D.limit_right -= 2
			$Camera2D.limit_left -= 2
			if $Camera2D.limit_right == 0:
				moving = false
				stop = true

func change_map():
	$map/AllMaps.frame = (GameData.get_stage() - 1)
	$foreground/DoorFore.frame = (GameData.get_stage() - 1)
	$foreground/DoorFore3.frame = (GameData.get_stage() - 1)
	$foreground/DoorFore5.frame = (GameData.get_stage() - 1)
	$foreground/DoorFore7.frame = (GameData.get_stage() - 1)
	if GameData.get_room() == 5:
		if GameData.get_stage() != 4:
			$map/map_up.frame = GameData.get_stage()
			$map/map_right.frame = GameData.get_stage() 
			$map/map_down.frame = GameData.get_stage()
			$map/map_left.frame = GameData.get_stage()
			$foreground/DoorFore2.frame = GameData.get_stage()
			$foreground/DoorFore4.frame = GameData.get_stage()
			$foreground/DoorFore6.frame = GameData.get_stage()
			$foreground/DoorFore8.frame = GameData.get_stage()
		else:
			$map/map_up.frame = 0
			$map/map_right.frame = 0
			$map/map_down.frame = 0
			$map/map_left.frame = 0
			$foreground/DoorFore2.frame = 0
			$foreground/DoorFore4.frame = 0
			$foreground/DoorFore6.frame = 0
			$foreground/DoorFore8.frame = 0
	else:
		$map/map_up.frame = (GameData.get_stage() - 1)
		$map/map_right.frame = (GameData.get_stage() - 1)
		$map/map_down.frame = (GameData.get_stage() - 1)
		$map/map_left.frame = (GameData.get_stage() - 1)
		$foreground/DoorFore2.frame = (GameData.get_stage() - 1)
		$foreground/DoorFore4.frame = (GameData.get_stage() - 1)
		$foreground/DoorFore6.frame = (GameData.get_stage() - 1)
		$foreground/DoorFore8.frame = (GameData.get_stage() - 1)

func spawn_players():
	var player_1 = PLAYER_1_PATH.instantiate()
	var player_2 = PLAYER_2_PATH.instantiate()
	match GameData.get_player_spawn_direction():
		0:
			player_1.position = $player_spawn/player_1_spawner.global_position
			get_parent().add_child(player_1)
			if GameData.get_game_mode() == 2:
				#var player_2 = PLAYER_2_PATH.instantiate()
				player_2.position = $player_spawn/player_2_spawner.global_position
				get_parent().add_child(player_2)
				print("Done")
		1:
			player_1.position = $player_spawn/south.global_position
			get_parent().add_child(player_1)
			if GameData.get_game_mode() == 2:
				#var player_2 = PLAYER_2_PATH.instantiate()
				player_2.position = $player_spawn/south.global_position
				get_parent().add_child(player_2)
		2:
			player_1.position = $player_spawn/west.global_position
			get_parent().add_child(player_1)
			if GameData.get_game_mode() == 2:
				#var player_2 = PLAYER_2_PATH.instantiate()
				player_2.position = $player_spawn/west.global_position
				get_parent().add_child(player_2)
		3:
			player_1.position = $player_spawn/north.global_position
			get_parent().add_child(player_1)
			if GameData.get_game_mode() == 2:
				player_2.position = $player_spawn/north.global_position
				get_parent().add_child(player_2)
		4:
			player_1.position = $player_spawn/east.global_position
			get_parent().add_child(player_1)
			if GameData.get_game_mode() == 2:
				player_2.position = $player_spawn/east.global_position
				get_parent().add_child(player_2)
		_:
			print("ERROR")

func destroy_player_to_move(body):
	if body.player_id == 1:
		var target = get_node("/root/player_2")
		if target:
			get_node("/root/player_2").queue_free()
	else:
		var target = get_node("/root/player_test")
		if target:
			get_node("/root/player_test").queue_free()

func change_music():
	if GameData.get_room() != 5:
		MusicController.play_combat()
	else:
		MusicController.play_boss()

func open_gates():
	var number_pool = [1,2,3,4]
	rng.randomize()
	number_pool.shuffle()
	var count = rng.randi_range(1,4)
	var number_result = number_pool.slice(0,count)
	print(number_result)
	for door in number_result:
		match door:
			1:
				$arrow/arrow3.visible = true
				$tiles/doors/door_up.enabled = false
			2:
				$arrow/arrow.visible = true
				$tiles/doors/door_right.enabled = false
			3:
				$arrow/arrow4.visible = true
				$tiles/doors/door_down.enabled = false
			4:
				$arrow/arrow2.visible = true
				$tiles/doors/door_left.enabled = false

func delete_leftover():
	var leftover = get_tree().get_nodes_in_group("dynamic")
	for obj in leftover:
		obj.queue_free()

func _on_west_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.changing_room(4)
		GameData.set_player_spawn_direction(4)
		moving = true
		if GameData.get_game_mode() == 2:
			destroy_player_to_move(body)

func _on_north_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.changing_room(1)
		GameData.set_player_spawn_direction(1)
		moving = true
		if GameData.get_game_mode() == 2:
			destroy_player_to_move(body)

func _on_east_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.changing_room(2)
		GameData.set_player_spawn_direction(2)
		moving = true
		if GameData.get_game_mode() == 2:
			destroy_player_to_move(body)

func _on_south_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.changing_room(3)
		GameData.set_player_spawn_direction(3)
		moving = true
		if GameData.get_game_mode() == 2:
			destroy_player_to_move(body)

func _on_room_stop_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.changing_room(0)
		GameData.set_total_rooms(GameData.get_total_rooms() + 1)
		GameData.set_room(GameData.get_room() + 1)
		if GameData.get_room() == 6:
			GameData.set_room(1)
			GameData.set_stage(GameData.get_stage() + 1)
			if GameData.get_stage() == 5:
				GameData.set_stage(1)
		GameData.set_number_of_enemies(30 + GameData.get_total_rooms())
