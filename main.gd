extends Node2D

@onready var player = $Player
@onready var enemy = $EnemyCenter
@onready var shoot = $Player/ShootComponent
@onready var ammo_label = $CanvasLayer/AmmoLabel
@onready var bullet_icon = $CanvasLayer/BulletSprite

var game_over = false
var level := 1

func _ready():
	shoot.ammo_changed.connect(_on_ammo_changed)

	# initialize UI
	_on_ammo_changed(shoot.current_ammo, shoot.max_ammo)
	var player_health = player.get_node("HealthComponent")
	var enemy_health = enemy.get_node("HealthComponent")

	player_health.died.connect(_on_player_died)
	enemy_health.died.connect(_on_enemy_died)

func _on_player_died():
	if game_over: return
	game_over = true
	#print("YOU LOSE")
	get_tree().paused = true

func _on_enemy_died():
	if game_over: return
	level += 1
	start_next_level()
	#print("YOU WIN")
	
func _on_ammo_changed(current, max_ammo):
	if shoot.is_reloading:
		bullet_icon.visible = false
		ammo_label.text = "Reloading..."
	else:
		ammo_label.text = " %d / %d" % [current, max_ammo]
		bullet_icon.visible = true

func start_next_level():
	var enemy = $EnemyCenter   # your correct node

	# 🔥 reset health
	var health = enemy.get_node("HealthComponent")
	health.current_health = health.max_health
	health.emit_signal("health_changed", health.current_health, health.max_health)

	# 🔥 reset position
	enemy.global_position = Vector2(500, 300)

	# 🔥 change behavior
	match level:
		1:
			enemy.enemy_type = "basic"
		2:
			enemy.enemy_type = "fast"

	# 🔥 APPLY NEW TYPE (IMPORTANT)
	enemy.apply_enemy_type()

	print("Enemy reset for level:", level)
