extends Node

@export var fire_rate = 1.5   # seconds between shots
@onready var owner_node = get_parent()
@onready var bullet_scene = preload("res://enemy_bullet.tscn")
@export var player: Node2D

#bullet sprtes
var normal_bullet_texture = preload("res://Assets/Bullets/DarkBall.png")
var phase2_bullet_texture = preload("res://Assets/Bullets/ColdIronShot.png")
var phase3_bullet_texture = preload("res://Assets/Bullets/spiderBullet.png")
var phase4_bullet_texture = preload("res://Assets/Bullets/Space_Acid.png")
var current_bullet_texture

enum AttackMode {
	BASIC,
	PREDICTIVE,
	MIXED
}
var attack_mode = AttackMode.BASIC
var shot_count := 0

var target_rotation := 0.0

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

	shot_count += 1

	var target_position = player.global_position

	var orbit = player.get_node("OrbitComponent")

	# PHASE 2: fully predictive
	if attack_mode == AttackMode.PREDICTIVE:

		var prediction_time = 20

		target_position += orbit.velocity * prediction_time

	# PHASE 3: mixed targeting
	elif attack_mode == AttackMode.MIXED:

		# every 3rd shot becomes normal
		if shot_count % 3 != 0:

			var prediction_time = 20

			target_position += orbit.velocity * prediction_time

	# Aim direction
	var dir = (target_position - owner_node.global_position).normalized()

	# Desired enemy rotation
	target_rotation = dir.angle() - PI / 2
	await get_tree().create_timer(0.2).timeout

	# Spawn bullet
	var bullet = bullet_scene.instantiate()

	get_tree().current_scene.add_child(bullet)

	bullet.set_bullet_texture(current_bullet_texture)

	bullet.global_position = owner_node.global_position

	bullet.direction = dir

func _process(delta):

	owner_node.rotation = lerp_angle(
		owner_node.rotation,
		target_rotation,10 * delta
	)
