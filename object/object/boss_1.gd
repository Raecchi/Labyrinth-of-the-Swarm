extends "res://scripts/enemy_script.gd"

const ENEMY_COMMON_PATH = preload("res://object/enemy_common.tscn")
const EXPLOSION_PATH = preload("res://object/explosion.tscn")

#var rng = RandomNumberGenerator.new()
var rng_number = 0
var dead = false

var direction = Vector2.ZERO

var timer = 0
var target_location = Vector2.ZERO
var born_ready = false

func _ready():
	hp = 60
	if GameData.get_game_mode() == 2:
		hp *= 2

func _physics_process(delta):
	if !dead and born_ready:
		if timer != 180:
			timer += 1
		else:
			$AnimationPlayer.play("jump")
			timer = 0
		if position.distance_to(target_location) > speed * delta:
			position += direction * speed * delta
		
		if hp <= 0:
			dead = true
			timer = 0
			#queue_free()
	
	elif dead:
		timer += 1
		if timer % 15 == 0:
			var explosion = EXPLOSION_PATH.instantiate()
			explosion.position = global_position
			explosion.position.x += rng.randi_range(-32, 32)
			explosion.position.y += rng.randi_range(-32, 32)
			get_parent().add_child(explosion)
		if timer == 180:
			boss_scoring()
			GameData.set_room_clear(true)
			queue_free()


func spawn_enemies():
	#var enemy = ENEMY_COMMON_PATH.instantiate()
	for i in 6:
		var enemy = ENEMY_COMMON_PATH.instantiate()
		match i:
			0:
				enemy.position = $spawners/left_top.global_position
			1:
				enemy.position = $spawners/left_mid.global_position
			2:
				enemy.position = $spawners/left_bot.global_position
			3:
				enemy.position = $spawners/right_top.global_position
			4:
				enemy.position = $spawners/right_mid.global_position
			5:
				enemy.position = $spawners/right_bot.global_position
		print(i)
		get_parent().add_child(enemy)

func pick_target():
	rng_number = rng.randi_range(0,4)
	#Marks the target location of jumping.
	match rng_number:
		0:
			target_location = $regions/mid.global_position
		1:
			target_location = $regions/top_left.global_position
		2:
			target_location = $regions/top_right.global_position
		3:
			target_location = $regions/bot_left.global_position
		4:
			target_location = $regions/bot_right.global_position
		
	direction = (target_location-position).normalized()
	var distance = position.distance_to(target_location)
	speed = distance 

func ready_up():
	born_ready = true
