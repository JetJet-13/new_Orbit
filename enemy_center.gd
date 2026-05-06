extends Node2D
@onready var health = $HealthComponent
@export var enemy_type := "basic"
@export var fire_rate := 0.4

func _ready():
	match enemy_type:
		"basic":
			fire_rate = 0.5

		"fast":
			fire_rate = 0.3
	health.died.connect(die)

func die():
	print("Enemy died")
	queue_free()
