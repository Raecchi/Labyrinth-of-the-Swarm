extends "res://scripts/enemy_script.gd"

#@export_node_path("CharacterBody2D") var target_path

#var target
var range_mode = false

func _ready():
	hp = 1
	speed = 60
	call_deferred("_find_player")
	#target = get_node("../player_test") 
	#if !target:
		#print("Not found")
	#var target = get_node(target_path)
	#print("ready")

func _physics_process(delta):
	if !target:
		switch_target()
	var direction = (target.position - position).normalized()
	position += direction * speed * delta
	if hp <= 0:
		drop_power()
		scoring()
		GameData.set_enemies_dead(GameData.get_enemies_dead() + 1)
		queue_free()
	




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

#func _find_player():
	#target = get_node("/root/player_test")
	#if !target:
		#print("Not Found")
