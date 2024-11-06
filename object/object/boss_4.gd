extends "res://scripts/enemy_script.gd"

const ARM_PATH = preload("res://object/boss_4_arm.tscn")
const EXPLOSION_PATH = preload("res://object/explosion.tscn")

#var rng = RandomNumberGenerator.new()

var timer = 0
#var target
var arm_in_times = 0
var attacking = false
var attacking_timer = 0
var triggered_1 = false
var triggered_2 = false
var dead = false


func _ready():
	hp = 150
	if GameData.get_game_mode() == 2:
		hp *= 2
	GameData.set_boss_4_arm_amount( - (GameData.get_boss_4_arm_amount() - 1))
	call_deferred("_find_player")

func _physics_process(delta):
	if !target:
		switch_target()
	if !dead:
		timer += 1
		if timer == 300:
			$AnimationPlayer.play("hit")
		if attacking == true:
			attacking_timer += 1
			if attacking_timer % 60 == 0 and arm_in_times < GameData.get_boss_4_arm_amount():
				spawn_hand()
			if GameData.get_boss_4_arm_amount() == GameData.get_boss_4_arm_disappear():
				$AnimationPlayer.play("arm_out")
				attacking = false
				arm_in_times = 0
				GameData.reset_boss_4_arm_disappear()
				attacking_timer = 0
				timer = 0
		
		if hp <= 0:
			dead = true
			timer = 0
			#queue_free()
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
	
	if (hp >= 98 and hp <= 100) and triggered_1 == false:
		GameData.set_boss_4_arm_amount(1)
		triggered_1 = true
		print ("amount increased to 2")
	
	if (hp >= 48 and hp <= 50) and triggered_2 == false:
		GameData.set_boss_4_arm_amount(1)
		triggered_2 = true
		print("amount increased to 3")
		


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "spawn_in":
		$AnimationPlayer.play("idle")
	if anim_name == "hit":
		$AnimationPlayer.play("arm_loop")
		attacking = true
	if anim_name == "arm_out":
		$AnimationPlayer.play("idle")
		

func spawn_hand():
	var hand = ARM_PATH.instantiate()
	hand.position = target.global_position
	get_parent().add_child(hand)
	arm_in_times += 1
	
#func _find_player():
	#target = get_node("/root/player_test")
	#if !target:
		#print("Not Found")


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !body.invincibility and !body.is_hurt:
		body.hp -= 1
		if body.player_id == 1:
			GameData.set_player_1_hp(body.hp)
		elif body.player_id == 2:
			GameData.set_player_2_hp(body.hp)
		body.is_hurt = true
		body.moveable = false
		body.modulate = Color(1,1,1,0.5)
		SfxController.play_hurt()
