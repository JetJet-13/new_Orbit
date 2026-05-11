extends Node2D

@onready var player = $Player
@onready var enemy = $EnemyCenter
@onready var shoot = $Player/ShootComponent
@onready var ammo_label = $CanvasLayer/AmmoLabel
@onready var bullet_icon = $CanvasLayer/AmmoLabel/BulletSprite

@onready var health_label = $CanvasLayer/HealthLabel

var game_over = false
var level := 1

func _ready():
	shoot.ammo_changed.connect(_on_ammo_changed)

	# initialize UI
	_on_ammo_changed(shoot.current_ammo, shoot.max_ammo)
	
	var player_health = player.get_node("HealthComponent")
	player_health.health_changed.connect(_on_health_changed)
	var enemy_health = enemy.get_node("HealthComponent")
	_on_health_changed(player_health.current_health, player_health.max_health)
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
	
	#print("YOU WIN")
	
func _on_ammo_changed(current, max_ammo):
	if shoot.is_reloading:
		bullet_icon.visible = false
		ammo_label.text = "Reloading..."
	else:
		ammo_label.text = " %d / %d" % [current, max_ammo]
		bullet_icon.visible = true
		
func _on_health_changed(current, max_health):
	health_label.text = "%d / %d" % [current, max_health]
