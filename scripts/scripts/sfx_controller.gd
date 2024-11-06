extends Node

var bullet_hit = preload("res://sound/sfx/shoot_hit.wav")
var bullet = preload("res://sound/sfx/shoot.wav")
var death = preload("res://sound/sfx/death.wav")
var explosion = preload("res://sound/sfx/explosion.wav")
var hurt = preload("res://sound/sfx/hurt.wav")
var laser = preload("res://sound/sfx/laser.wav")
var laser_hit = preload("res://sound/sfx/laser_hit.wav")
var life_up = preload("res://sound/sfx/life_up.wav")
var pick_up = preload("res://sound/sfx/pick_up.wav")
var select = preload("res://sound/sfx/select.wav")
var switch = preload("res://sound/sfx/select_switch.wav")

func play_bullet_hit():
	$sfx.stream = bullet_hit
	$sfx.volume_db = -10
	$sfx.play()

func play_shoot():
	$sfx.stream = bullet
	$sfx.volume_db = -10
	$sfx.play()

func play_death():
	$sfx.stream = death
	$sfx.volume_db = 0
	$sfx.play()

func play_explosion():
	$sfx.stream = explosion
	$sfx.volume_db = 0
	$sfx.play()

func play_hurt():
	$sfx.stream = hurt
	$sfx.volume_db = 0
	$sfx.play()

func play_laser():
	$sfx.stream = laser
	$sfx.volume_db = 0
	$sfx.play()

func play_laser_hit():
	$sfx.stream = laser
	$sfx.volume_db = 0
	$sfx.play()

func play_life_up():
	$sfx.stream = life_up
	$sfx.play()
	$sfx.volume_db = 0
	await $sfx.finished

func play_pick_up():
	$sfx.stream = pick_up
	$sfx.volume_db = 0
	$sfx.play()
	await $sfx.finished

func play_select():
	$sfx.stream = select
	$sfx.volume_db = 0
	$sfx.play()

func play_switch():
	$sfx.stream = switch
	$sfx.volume_db = 0
	$sfx.play()
