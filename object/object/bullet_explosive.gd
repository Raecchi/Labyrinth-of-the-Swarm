extends Area2D

const BULLET_HIT_PATH = preload("res://object/explosion.tscn")

var speed = 3.5
var direction = Vector2.ZERO
var player_id = 0

func _physics_process(delta):
	position += direction * speed 


func bullet_rotate():
	if direction != Vector2.ZERO:
		rotation = direction.angle()


func _on_body_entered(body):
	#if body.is_in_group("player"):
		#pass
	#else:
		#var explosion = BULLET_HIT_PATH.instantiate()
		#explosion.position = global_position
		#get_parent().add_child(explosion)
		#queue_free()
	if !body.is_in_group("player"):
		var explosion = BULLET_HIT_PATH.instantiate()
		explosion.position = global_position
		explosion.player_id = player_id
		get_parent().add_child(explosion)
		queue_free()
