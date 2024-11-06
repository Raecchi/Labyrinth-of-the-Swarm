extends "res://scripts/enemy_script.gd"

const BOSS_2_PROJECTILE_PATH = preload("res://object/boss_2_bullet.tscn")
const EXPLOSION_PATH = preload("res://object/explosion.tscn")

var RNG = RandomNumberGenerator.new()
var rng_number = 0

#var target
var timer = 0
var stage = 0
var bullet_counter = 2
var played = false
var last_position
var direction #= Vector2.ZERO
var dead = false

func _ready():
	call_deferred("_find_player")
	#target = get_node("../player_test") 
	hp = 60
	if GameData.get_game_mode() == 2:
		hp *= 2

func _physics_process(delta):
	if !target:
		switch_target()
	if !dead:
		$Marker2D.global_position = target.position
		timer += 1
		#print(timer)
		boss_ai(delta)
		
		if hp <= 0:
			dead = true
			timer = 0
			#queue_free()
	
	else:
		timer += 1
		if timer % 15 == 0:
			var explosion = EXPLOSION_PATH.instantiate()
			explosion.position = global_position
			explosion.position.x += RNG.randi_range(0,32)
			explosion.position.y += RNG.randi_range(-32,32)
			get_parent().add_child(explosion)
		if timer == 180:
			boss_scoring()
			GameData.set_room_clear(true)
			queue_free()

func _on_hitbox_body_entered(body):
	if body.is_in_group("player") and body.invincibility == false and body.is_hurt == false:
		body.hp -= 1
		if body.player_id == 1:
			GameData.set_player_1_hp(body.hp)
		elif body.player_id == 2:
			GameData.set_player_2_hp(body.hp)
		#print(body.hp)
		body.is_hurt = true
		body.moveable = false
		body.modulate = Color(1,1,1,0.5)
		SfxController.play_hurt()


#func _find_player():
	##target = get_node("../player_test") 
	#target = get_node("/root/player_test")
	#if !target:
		#print("Not Found")
		#

func shoot_ball():
	var direction = (target.position - position).normalized()
	var new_bullet = BOSS_2_PROJECTILE_PATH.instantiate()
	new_bullet.position = global_position 
	new_bullet.direction = direction
	get_parent().add_child(new_bullet)
	timer = 0


func set_stage(target_stage: int):
	stage = target_stage
	played = false

func reset_timer():
	timer = 0
	
	
func boss_ai(delta):
	match stage:
		0:
			if !played:
				$AnimationPlayer.play("spawn")
				rng_number = RNG.randi_range(1,3)
				bullet_counter = rng_number
				played = true
		1:
			if bullet_counter > 0:
				if timer == 90:
					$AnimationPlayer.play("shoot")
					timer = 0
					bullet_counter -= 1
			else:
				played = false
				stage = 2
		2:
			if !played:
				$AnimationPlayer.play("shrink")
				played = true
		3:
			if !played:
				$AnimationPlayer.play("move")
				played = true
			if timer == 90:
				last_position = target.global_position
				#print(last_position)
				direction = (last_position - position).normalized()
				speed = position.distance_to(last_position)
				#print("target acquired")
			if timer >= 120:
				if position.distance_to(last_position) > speed * delta:
					position += direction * speed * delta
				elif (position.distance_to(last_position) <= speed * delta) or timer == 180:
					stage = 0
					played = false
					timer = 0
				
