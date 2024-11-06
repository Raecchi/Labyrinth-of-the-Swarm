extends "res://scripts/enemy_script.gd"

const RANGE_BULLET_PATH = preload("res://object/enemy_range_bullet.tscn")

#var target
var timer = 0
var range_mode = true

func _ready():
	hp = 2
	call_deferred("_find_player")
	#target = get_node("../player_test")
	#if !target:
		#print("Not found")


func _physics_process(delta):
	if !target:
		switch_target()
	$Marker2D.global_position = target.position
	timer += 1
	if timer == 120:
		$AnimatedSprite2D.play("shoot")
		
	if timer == 150:
		shoot_ball(target.position)
	
	
	if hp <= 0:
		drop_power()
		scoring()
		GameData.set_enemies_dead(GameData.get_enemies_dead() + 1)
		queue_free()

func shoot_ball(player_position):
	var direction = (player_position - position).normalized()
	var new_bullet = RANGE_BULLET_PATH.instantiate()
	new_bullet.position = global_position
	new_bullet.direction = direction
	get_parent().add_child(new_bullet)
	timer = 0
	
#func _find_player():
	#target = get_node("/root/player_test")
	#if !target:
		#print("Not found")
