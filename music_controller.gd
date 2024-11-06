extends Node

var calm = preload("res://sound/music/febblemask_custom_calm.wav")
var combat = preload("res://sound/music/febblemask_custom_combat.wav")
var boss = preload("res://sound/music/febblemask_custom_boss.wav")

var play_position = 0.0

func play_calm():
	play_position = $music.get_playback_position()
	$music.stream = calm
	$music.play(play_position)

func play_combat():
	play_position = $music.get_playback_position()
	$music.stream = combat
	$music.play(play_position)

func play_boss():
	play_position = $music.get_playback_position()
	$music.stream = boss
	$music.play(play_position)

func stop():
	$music.stop()
