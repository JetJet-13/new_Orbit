extends Node

@onready var sprite = get_parent().get_node("Sprite2D")



var normal_texture = preload("res://Assets/Enemy/DarkWaveShip.png")
var phase2_texture = preload("res://Assets/Enemy/ColdIron.png")
var phase3_texture = preload("res://Assets/Enemy/SpiderShip.png")
var phase4_texture = preload("res://Assets/Enemy/Baron.png")

func set_phase_1():
	sprite.texture = normal_texture
	
func set_phase_2():
	sprite.texture = phase2_texture
	
func set_phase_3():
	sprite.texture = phase3_texture

func set_phase_4():
	sprite.texture = phase4_texture
	
