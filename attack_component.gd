extends Node

@export var fire_rate = 1.5   # seconds between shots
@onready var owner_node = get_parent()
@onready var bullet_scene = preload("res://enemy_bullet.tscn")
@export var player: Node2D

var normal_bullet_texture = preload("res://Assets/Bullets/DarkBall.png")
var phase2_bullet_texture = preload("res://Assets/Bullets/ColdIronShot.png")

var current_bullet_texture

func _ready():
	current_bullet_texture = normal_bullet_texture
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

	bullet.set_bullet_texture(current_bullet_texture)

	bullet.global_position = owner_node.global_position

	var dir = (player.global_position - owner_node.global_position).normalized()

	bullet.direction = dir
