extends Node

@onready var owner_node = get_parent()
@onready var bullet_scene = preload("res://bullet.tscn")
@export var center_node: Node2D
@export var max_ammo := 8
@export var reload_time := 1.5
@onready var orbit_component = get_parent().get_node("OrbitComponent")

var current_ammo := max_ammo
var is_reloading := false

signal ammo_changed(current, max)

func shoot():
	
	orbit_component.current_tilt = 2
	
	if center_node == null:
		return

	# 🚫 can't shoot while reloading
	if is_reloading:
		return

	# 🚫 no ammo
	if current_ammo <= 0:
		start_reload()
		return

	# 🔫 SHOOT
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)

	bullet.global_position = owner_node.global_position

	var dir = (center_node.global_position - owner_node.global_position).normalized()
	bullet.direction = dir

	current_ammo -= 1
	emit_signal("ammo_changed", current_ammo, max_ammo)
	#print("Ammo:", current_ammo)

	# 🔄 auto reload when empty
	if current_ammo <= 0:
		start_reload()
	
	await get_tree().create_timer(0.8).timeout
	orbit_component.shoot_tilt = false

func start_reload():
	if is_reloading:
		return

	is_reloading = true
	emit_signal("ammo_changed", current_ammo, max_ammo)
	#print("Reloading...")

	await get_tree().create_timer(reload_time).timeout

	current_ammo = max_ammo
	is_reloading = false
	emit_signal("ammo_changed", current_ammo, max_ammo)
