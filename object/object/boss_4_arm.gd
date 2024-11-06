extends Area2D

const ENEMY_COMMON_PATH = preload("res://object/enemy_common.tscn")

var timer = 0
var enemy_timer = 0
var spawning_time = false
var enemy_counter = 10

func _physics_process(delta):
	timer += 1
	if timer == 30:
		$AnimationPlayer.play("spawn_in")
		
	if spawning_time:
		enemy_timer += 1
		if enemy_timer % 15 == 0:
			var enemy = ENEMY_COMMON_PATH.instantiate()
			enemy.position = position
			get_parent().add_child(enemy)
			enemy_counter -= 1
			if enemy_counter <= 0:
				$AnimationPlayer.play("spawn_out")
				#GameData.set_boss_4_arm_disappear(1)
				#print(GameData.get_boss_4_arm_disappear())

func spawning_time_activate():
	spawning_time = true
	
func set_boss_arm_disappear():
	GameData.set_boss_4_arm_disappear(1)
	print(GameData.get_boss_4_arm_disappear())
