extends Node

@export var fire_rate = 1.5   # seconds between shots
@onready var owner_node = get_parent()
@onready var bullet_scene = preload("res://enemy_bullet.tscn")
@export var player: Node2D


func _ready():
	start_firing()


func start_firing():
	while true:
		await get_tree().create_timer(fire_rate).timeout
		shoot()


func shoot():
	if player == null:
		return

	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)

	bullet.global_position = owner_node.global_position

	var dir = (player.global_position - owner_node.global_position).normalized()
	bullet.direction = dir
