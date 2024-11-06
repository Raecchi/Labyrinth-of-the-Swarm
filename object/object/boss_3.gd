extends "res://scripts/enemy_script.gd"

const FIRE_BALL_PATH = preload("res://object/fire_ball.tscn")
const EXPLOSION_PATH = preload("res://object/explosion.tscn")

var can_move = true
var timer = 0
#var rng = RandomNumberGenerator.new()
var rng_number = 0
var right_left = true
var shoot_timer = 0
var red_eye = false
var dead = false
var born_ready = false

func _ready():
	hp = 120
	if GameData.get_game_mode() == 2:
		hp *= 2
	speed = -90
	rng_number = rng.randi_range(60,240)
	
func _physics_process(delta):
	if !dead:
		#print(speed)
		if can_move:
			timer += 1
			if right_left:
				speed -= 1
				if speed <= -90:
					right_left = false
			else:
				speed += 1
				if speed >= 90:
					right_left = true
			velocity.x = speed
			move_and_slide()
			if timer == rng_number:
				can_move = false
		else:
			shoot()
			
		
		if hp <= 0:
			dead = true
			timer = 0
	
	else: 
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

func shoot():
	shoot_timer += 1
	if shoot_timer >= 30:
		if red_eye:
			$head.frame = 3
			red_eye = false
		else:
			$head.frame = 4
			red_eye = true
		if shoot_timer == 60:
			var fireball = FIRE_BALL_PATH.instantiate()
			fireball.position = $Marker2D.global_position
			get_parent().add_child(fireball)
			shoot_timer = 0
			timer = 0
			can_move = true


func _on_hitbox_body_entered(body):
	if body.is_in_group("player") and !body.invincibility and !body.is_hurt:
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

func ready_up():
	born_ready = true
