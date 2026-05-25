extends Node

@onready var player_a = $PlayerA
@onready var player_b = $PlayerB

@onready var active_player = player_a
@onready var inactive_player = player_b

func play_music(track):

	if active_player.stream == track and active_player.playing:
		return

	inactive_player.stream = track
	inactive_player.volume_db = -40
	inactive_player.play()

	var tween = create_tween()

	tween.tween_property(
		active_player,
		"volume_db",
		-40,
		1.0
	)

	tween.parallel().tween_property(
		inactive_player,
		"volume_db",
		0,
		1.0
	)

	await tween.finished

	active_player.stop()

	var temp = active_player
	active_player = inactive_player
	inactive_player = temp
