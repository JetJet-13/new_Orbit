extends Node

@onready var owner_node = get_parent()
@export var center_node: Node2D

var angle = 0.0
var radius = 200.0
var angular_speed = 2.0
var direction = 1

# Dash
var is_dashing = false
var dash_speed = 8.0
var dash_duration = 0.25
var can_dash = true
var dash_cooldown = 0.4

func _process(delta):
	# 🛑 Safety checks (prevents your crash)
	if center_node == null or not is_instance_valid(center_node):
		return

	if owner_node == null or not is_instance_valid(owner_node):
		return

	# 🎯 Choose speed
	var speed = dash_speed if is_dashing else angular_speed

	# 🔄 Update angle
	angle += direction * speed * delta

	# 🌀 Orbit position
	var offset = Vector2(cos(angle), sin(angle)) * radius
	owner_node.global_position = center_node.global_position + offset

	# 🔁 Face center
	var dir_to_center = (center_node.global_position - owner_node.global_position).normalized()
	owner_node.rotation = dir_to_center.angle() + PI / 1


func handle_direction_input(input_dir):
	if input_dir == direction:
		try_dash()
	else:
		direction = input_dir


func try_dash():
	if not can_dash or is_dashing:
		return

	dash()


func dash():
	is_dashing = true
	can_dash = false

	await get_tree().create_timer(dash_duration).timeout
	is_dashing = false

	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true
