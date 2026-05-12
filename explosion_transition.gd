extends Node2D

@onready var explosion = $AnimatedSprite2D


func _ready():

	explosion.play("Explosion")

	explosion.animation_finished.connect(_on_finished)


func _on_finished():

	queue_free()
