extends Node

signal health_changed(current, max)
signal died

@export var max_health: int = 10
@export var use_invincibility := true
@export var invincibility_time := 0.5

var current_health: int
var is_invincible := false

var explosion_scene = preload("res://explosion_transition.tscn")

# flashing
var flashing := false
var flash_speed := 0.08

func _ready():
	current_health = max_health
	emit_signal("health_changed", current_health, max_health)


func take_damage(amount: int, hit_position = null):
	if hit_position != null:

		var explosion = explosion_scene.instantiate()

		get_tree().current_scene.add_child(explosion)
		var random_offset = Vector2(
			randf_range(-10, 10),
			randf_range(-10, 10)
		)

		explosion.global_position = hit_position + random_offset

		explosion.set_explosion_scale(0.1)
	
	# 🛑 block damage if invincible
	
	if use_invincibility and is_invincible:
		return

	current_health -= amount
	current_health = max(current_health, 0)

	#print("HP:", current_health)

	emit_signal("health_changed", current_health, max_health)

	if current_health <= 0:
		emit_signal("died")
		await get_tree().create_timer(0.5, true).timeout
		get_tree().paused = false
		get_tree().change_scene_to_file("res://game_over.tscn")
		return

	# 🟢 start i-frames
	if use_invincibility:
		start_invincibility()


func heal(amount: int):
	current_health += amount
	current_health = min(current_health, max_health)

	emit_signal("health_changed", current_health, max_health)


# =========================
# 🔥 INVINCIBILITY SYSTEM
# =========================

func start_invincibility():
	print ("invincible")
	is_invincible = true

	if get_parent().has_method("start_flash"):
		get_parent().start_flash()

	await get_tree().create_timer(invincibility_time).timeout

	is_invincible = false

	if get_parent().has_method("stop_flash"):
		get_parent().stop_flash()
