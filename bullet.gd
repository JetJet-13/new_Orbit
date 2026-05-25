extends Area2D

@export var speed = 800.0
@export var damage = 1

var target_scale = Vector2.ONE
var direction: Vector2 = Vector2.ZERO

func _ready():
	scale = Vector2(0.3, 0.3)
	connect("area_entered", Callable(self, "_on_area_entered"))

func _process(delta):
	scale = scale.lerp(target_scale, 12 * delta)
	global_position += direction * speed * delta

	if direction != Vector2.ZERO:
		rotation = direction.angle() + PI / 2


func _on_area_entered(area):
	# 🟡 only interact with bullets
	if not area.is_in_group("bullet"):
		return

	# 🔵 ignore player bullets
	if area.is_in_group("player_bullet"):
		return

	# 🔴 cancel enemy bullets
	queue_free()
	area.queue_free()
