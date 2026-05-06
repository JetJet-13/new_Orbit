extends Area2D

@export var takes_damage_from: String = "enemy_bullet"

@onready var health = get_parent().get_node("HealthComponent")

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area):
	if not area.is_in_group(takes_damage_from):
		return

	health.take_damage(1)
	area.queue_free()
