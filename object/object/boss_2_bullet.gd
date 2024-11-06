extends Area2D

const ENEMY_COMMON_PATH = preload("res://object/enemy_common.tscn")

var direction
var speed = 180
var timer = 0
var begin = false
var enemy_counter = 4


func _physics_process(delta):
	position += direction * speed * delta
	if begin == true:
		timer += 1
		if timer % 15 == 0:
			var enemy = ENEMY_COMMON_PATH.instantiate()
			enemy.position = position
			get_parent().add_child(enemy)
			enemy_counter -= 1
			#print("enemy_spawned")
			if enemy_counter <= 0:
				queue_free()


func _on_body_entered(body):
	if body.is_in_group("player") and body.invincibility == false and body.is_hurt == false:
		body.hp -= 1
		if body.player_id == 1:
			GameData.set_player_1_hp(body.hp)
		elif body.player_id == 2:
			GameData.set_player_2_hp(body.hp)
		body.is_hurt = true
		body.moveable = false
		body.modulate = Color(1,1,1,0.5)
		SfxController.play_hurt()
	else:
		speed = 0
		begin = true
	
