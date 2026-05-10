extends Node2D
@onready var health = $HealthComponent
@onready var attack = $AttackComponent
@onready var visuals = $VisualComponent

@export var fire_rate := 0.4

var phase_two_triggered := false

func _ready():
	health.died.connect(die)

func die():
	print("Enemy died")
	queue_free()

func _process(delta):
	if not phase_two_triggered:
		if health.current_health <= health.max_health / 2:
			enter_phase_two()

func enter_phase_two():
	phase_two_triggered = true
	print("PHASE 2")
	# 🔥 faster attacks
	attack.fire_rate = 0.2
	visuals.set_phase_2()
	attack.current_bullet_texture = attack.phase2_bullet_texture
