extends "res://scripts/character_script.gd"

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

var input_movement = Vector2.ZERO
var temp_timer = 0

func _ready():
	speed = 80

func _process(delta):
	
	#Old animation and movement
	
	#velocity = Vector2.ZERO
	#if Input.is_action_pressed("up"):
		#velocity.y -= 80
		#$AnimationPlayer.play("walk_up")
	#if Input.is_action_pressed("right"):
		#velocity.x += 80
		#$AnimationPlayer.play("walk_right")
	#if Input.is_action_pressed("down"):
		#velocity.y += 80
		#$AnimationPlayer.play("walk_down")
	#if Input.is_action_pressed("left"):
		#velocity.x -= 80
		#$AnimationPlayer.play("walk_left")
		
	#if velocity == Vector2.ZERO:
		#$AnimationPlayer.stop()
	
	get_movement()
	move_and_slide()
	
	temp_timer += 1
	print(temp_timer)
	#print($Sprite2D.frame)
	
	
func get_movement():
	input_movement = Input.get_vector("p1_left","p1_right","p1_up","p1_down")
	if input_movement != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", input_movement)
		anim_tree.set("parameters/Walk/blend_position", input_movement)
		anim_state.travel("Walk")
		velocity = speed * input_movement
		
	else:
		anim_state.travel("Idle")
		velocity = Vector2.ZERO
	#velocity.normalized()
