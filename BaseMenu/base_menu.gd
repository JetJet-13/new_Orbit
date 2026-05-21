extends Control

var menu_music =preload("res://Assets/Music/Approaching_Zenith.ogg")

func _ready():
	MusicManager.play_music(menu_music)

signal start_pressed
signal settings_pressed
signal quit_pressed

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_settings_button_pressed():
	emit_signal("settings_pressed")

func _on_quit_button_pressed():
	get_tree().quit()
