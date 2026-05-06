extends Node

@onready var orbit = get_parent().get_node("OrbitComponent")
@onready var shoot = get_parent().get_node("ShootComponent")
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		var screen_width = get_viewport().get_visible_rect().size.x
		var dir = -1 if event.position.x < screen_width / 2 else 1

		orbit.handle_direction_input(dir)
		shoot.shoot()
