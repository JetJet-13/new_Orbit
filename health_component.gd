extends Node

signal health_changed(current, max)
signal died

@export var max_health: int = 10
@export var use_invincibility := true
@export var invincibility_time := 0.5

var current_health: int
var is_invincible := false

# flashing
var flashing := false
var flash_speed := 0.08

func _ready():
	current_health = max_health
	emit_signal("health_changed", current_health, max_health)


func take_damage(amount: int):
	# 🛑 block damage if invincible
	if use_invincibility and is_invincible:
		return

	current_health -= amount
	current_health = max(current_health, 0)

	#print("HP:", current_health)

	emit_signal("health_changed", current_health, max_health)

	if current_health <= 0:
		emit_signal("died")
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
	is_invincible = true
	start_flash()

	await get_tree().create_timer(invincibility_time).timeout

	is_invincible = false
	stop_flash()


# =========================
# ✨ FLASHING EFFECT
# =========================

func start_flash():
	flashing = true
	flash_loop()


func stop_flash():
	flashing = false

	var sprite = get_parent().get_node("Sprite2D")
	sprite.visible = true


func flash_loop():
	while flashing:
		var sprite = get_parent().get_node("Sprite2D")
		sprite.visible = not sprite.visible
		await get_tree().create_timer(flash_speed).timeout
