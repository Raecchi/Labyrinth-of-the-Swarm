extends "res://scripts/character_script.gd"

@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

const BULLET_NORMAL_PATH = preload("res://object/bullet_normal.tscn")
const BULLET_LASER_PATH = preload("res://object/bullet_laser.tscn")
const BULLET_EXPLOSIVE_PATH = preload("res://object/bullet_explosive.tscn")


#ffffab is the color for invicncibility

var bullet_cooldown = 0
var shootable = true
var bullet_type = 0
var shotgun = false
var bullet_counter = 0
var change_gun = true

var input_direction = Vector2.ZERO
var input_shooting = Vector2.ZERO
var player_id = 0

var hurt_cooldown = 0
var is_hurt = false
var moveable = true
var alive = true
var changing = false
var once = false

var invincibility = false
var invincibility_timer = 0
var color_change = false
var speed_boost = false
var speed_timer = 0

#signal player_position(playe_position)

func _ready():
	#invincibility_material.blend_mode
	player_id = 1
	speed  = 80
	
	
	hp = GameData.get_player_1_hp()
	bullet_counter = GameData.get_player_1_ammo()
	bullet_type = GameData.get_player_1_gun_type()
	shotgun = GameData.get_player_1_shotgun()
	if GameData.get_player_1_bubble():
		turn_on_powerup(1)


func _physics_process(delta):
	
	#print(bullet_counter)
	
	match player_id:
		1:
			if hp != GameData.get_player_1_hp():
				hp = GameData.get_player_1_hp()
			GameData.set_player_1_gun_type(bullet_type)
			GameData.set_player_1_ammo(bullet_counter)
			GameData.set_player_1_shotgun(shotgun)
		2:
			if hp != GameData.get_player_2_hp():
				hp = GameData.get_player_2_hp()
			GameData.set_player_2_gun_type(bullet_type)
			GameData.set_player_2_ammo(bullet_counter)
			GameData.set_player_2_shotgun(shotgun)
	
	if moveable and alive and !changing:
		get_movement()
		move_and_slide()
	if is_hurt:
		hurt_cooldown += 1
		#print(hurt_cooldown)
		if hurt_cooldown == 15:
			moveable = true
		if hurt_cooldown == 90:
			is_hurt = false
			hurt_cooldown = 0
			modulate = Color(1,1,1,1)
	#move_and_slide()
	if shootable == false:
		shoot_cooldown()
	if bullet_counter == 0 and change_gun == true:
		bullet_type = 0
		if shotgun == true:
			shotgun = false
		change_gun = false
	#print(bullet_counter)
	if speed_boost == true:
		speed_timer += 1
		print(speed_timer)
		if speed_timer == 900:
			speed_boost = false
			speed = 80
	if invincibility:
		invincibility_timer += 1
		print(invincibility_timer)
		if invincibility_timer >= 600 and invincibility_timer % 30 == 0:
			if color_change:
				$Sprite2D.modulate = Color(1,1,1)
				color_change = false
			else:
				$Sprite2D.modulate = Color(0.675,0.7,0.455)
				color_change = true
		if invincibility_timer == 900:
			invincibility = false
			set_collision_layer_value(1,true)
			$Sprite2D.modulate = Color(1,1,1)
	
	if changing:
		velocity = speed * input_direction
		move_and_slide()
		#print("success?")
	
	if hp <= 0:
		alive = false
	
	if !alive and !once:
		anim_state.travel("death")
		$death.play()
		once = true
		await $death.finished
		GameData.set_total_player_deaths(GameData.get_total_player_deaths() + 1)
		queue_free()
	

func get_movement():
	#emit_signal ("player_position",global_position)
	match player_id:
		1:
			input_direction = Input.get_vector("p1_left", "p1_right", "p1_up", "p1_down")
		2:
			input_direction = Input.get_vector("p2_left", "p2_right", "p2_up", "p2_down")
	if input_direction != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", input_direction)
		anim_tree.set("parameters/Walk/blend_position", input_direction)
		anim_state.travel("Walk")
		velocity = speed * input_direction
		#print(input_direction)
		
	else:
		anim_state.travel("Idle")
		velocity = Vector2.ZERO
	
	match player_id:
		1:
			input_shooting = Input.get_vector("p1_shoot left","p1_shoot right","p1_shoot up","p1_shoot down")
		2:
			input_shooting = Input.get_vector("p2_shoot left","p2_shoot right","p2_shoot up","p2_shoot down")
	#input_shooting = snapping_movement(input_shooting)
	if input_shooting != Vector2.ZERO:
		if input_direction != Vector2.ZERO:
			#anim_tree.set("parameters/Shoot_Walk/blend_position", input_shooting)
			#anim_state.travel("Shoot_Walk")
			anim_tree.set("parameters/Walk/blend_position", input_shooting)
			anim_state.travel("Walk")
		else:
			#anim_tree.set("parameters/Shoot_Idle/blend_position", input_shooting)
			#anim_state.travel("Shoot_Idle")
			anim_tree.set("parameters/Idle/blend_position", input_shooting)
			anim_state.travel("Idle")
		
		$shoot_marker.position = input_shooting * 10
		if shootable:
			if shotgun == false:
				shoot_bullet(input_shooting)
			else:
				shoot_shotgun(input_shooting.normalized())
	
		
		
#Snapping the 8-directional movement. Scrapped
#func snapping_movement(direction):
	#var angle = direction.angle_to(Vector2.RIGHT)
	#var calculated_angle = round(angle / (PI / 4)) * (PI /4)
	#return Vector2.RIGHT.rotated(calculated_angle)

func shoot_bullet(input_direction):
	var bullet 
	match bullet_type:
		0:
			bullet = BULLET_NORMAL_PATH.instantiate()
		1:
			bullet = BULLET_LASER_PATH.instantiate()
		2:
			bullet = BULLET_EXPLOSIVE_PATH.instantiate()
	bullet.position = $shoot_marker.global_position
	bullet.player_id = player_id
	bullet.set("direction", input_direction.normalized())
	bullet.bullet_rotate()
	get_parent().add_child(bullet)
	if bullet_counter > 0:
		bullet_counter -= 1
	shootable = false
	
func shoot_shotgun(input_direction):
	var shotgun_directions = [input_direction, input_direction.rotated(-PI/12), input_direction.rotated(PI/12)]
	for i in shotgun_directions:
		shoot_bullet(i)

func shoot_cooldown():
	bullet_cooldown += 1
	#print(bullet_cooldown)
	match bullet_type:
		0:
			if shotgun == false:
				if bullet_cooldown == 10:
					shootable = true
					bullet_cooldown = 0
			else:
				if bullet_cooldown == 20:
					shootable = true
					bullet_cooldown = 0
		1:
			if bullet_cooldown == 20:
				shootable = true
				bullet_cooldown = 0
		2:
			if bullet_cooldown == 45:
				shootable = true
				bullet_cooldown = 0


func _on_bubble_body_entered(body):
	if !invincibility and !is_hurt:
		$bubble/CollisionShape2D.set_deferred("disabled",true)
		$bubble/Sprite2D.visible = false
		is_hurt = true
		match player_id:
			1:
				GameData.set_player_1_bubble(false)
			2:
				GameData.set_player_2_bubble(false)


func _on_bubble_area_entered(area):
	if !invincibility and !is_hurt:
		$bubble/CollisionShape2D.set_deferred("disabled",true)
		$bubble/Sprite2D.visible = false
		is_hurt = true
		match player_id:
			1:
				GameData.set_player_1_bubble(false)
			2:
				GameData.set_player_2_bubble(false)

#For Bubble and Invinsibility to change things inside of the player.
func turn_on_powerup(powerup):
	match powerup:
		1:
			$bubble/CollisionShape2D.set_deferred("disabled", false)
			$bubble/Sprite2D.visible = true
			match player_id:
				1:
					GameData.set_player_1_bubble(true)
				2:
					GameData.set_player_2_bubble(true)
		2:
			invincibility = true
			invincibility_timer = 0
			$Sprite2D.modulate = Color(0.675,0.7,0.455)
			#set_collision_layer_value(1,false)

func changing_room(direction):
	changing = true
	match direction:
		0:
			input_direction = Vector2(0,0)
		1:
			input_direction = Vector2(0,-1)
		2:
			input_direction = Vector2(1,0)
		3:
			input_direction = Vector2(0,1)
		4:
			input_direction = Vector2(-1,0)
