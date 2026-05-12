extends Node2D

@onready var explosion = $AnimatedSprite2D


func _ready():

	explosion.play("Explosion")

	explosion.animation_finished.connect(_on_finished)

func set_explosion_scale(size):
	scale = Vector2(size, size)

func _on_finished():

	queue_free()
