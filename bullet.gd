extends Area2D

@export var speed = 600.0
@export var damage = 1

var direction: Vector2 = Vector2.ZERO

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))

func _process(delta):
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
