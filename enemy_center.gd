extends Node2D
@onready var health = $HealthComponent
@onready var attack = $AttackComponent
@onready var visuals = $VisualComponent

@export var fire_rate := 0.4

var phase_two_triggered := false
var phase_three_triggered = false

var explosion_scene = preload("res://explosion_transition.tscn")
var upgrade_menu_scene = preload("res://upgrade_menu.tscn")

func _ready():
	health.died.connect(die)

func die():
	print("Enemy died")
	queue_free()

func _process(delta):

	# Phase 2
	if not phase_two_triggered:
		if health.current_health <= 95:
			enter_phase_two()

	# Phase 3
	if not phase_three_triggered:
		if health.current_health <= 88:
			enter_phase_three()

func enter_phase_two():
	phase_two_triggered = true
	#Transition to upgrade menu
	spawn_explosion()
	await get_tree().create_timer(0.5).timeout
	get_tree().paused = true
	show_upgrade_menu()

	print("PHASE 2")

	attack.fire_rate = 0.4

	visuals.set_phase_2()

	attack.current_bullet_texture = attack.phase2_bullet_texture
	
func enter_phase_three():
	phase_three_triggered = true
	#Transition to upgrade menu
	spawn_explosion()
	await get_tree().create_timer(0.5).timeout
	get_tree().paused = true
	show_upgrade_menu()
	
	attack.fire_rate = 0.3
	visuals.set_phase_3()
	attack.current_bullet_texture = attack.phase3_bullet_texture
	print("PHASE 3")

	attack.use_predictive_targeting = true
	
func spawn_explosion():

	var explosion = explosion_scene.instantiate()

	get_tree().current_scene.add_child(explosion)

	explosion.global_position = global_position
	
func _on_transition_finished():

	show_upgrade_menu()
	
func show_upgrade_menu():

	var menu = upgrade_menu_scene.instantiate()

	get_tree().current_scene.get_node("OverlayLayer").add_child(menu)
	
