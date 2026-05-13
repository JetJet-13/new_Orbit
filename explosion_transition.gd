extends Node2D

signal transition_finished

@onready var explosion = $AnimatedSprite2D


func _ready():

	explosion.play("Explosion")

	explosion.animation_finished.connect(_on_finished)


func set_explosion_scale(size):

	scale = Vector2(size, size)


func _on_finished():

	emit_signal("transition_finished")

	queue_free()
