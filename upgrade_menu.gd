extends Control

@onready var button1 = $VBoxContainer/Button
@onready var button2 = $VBoxContainer/Button2
@onready var button3 = $VBoxContainer/Button3

var upgrade_icons = {
	"+1 Ammo": preload("res://Assets/UI/Ammo.png"),
	"+1 Health": preload("res://Assets/UI/healthcore.png"),
	"-0.3s Reload": preload("res://Assets/UI/Reload_Icon.png"),
	"+0.8 Invincibility": preload("res://Assets/UI/Invincible_Icon.png"),
	"-0.2s DashCooldown": preload("res://Assets/UI/Dash Icon.png")
}

@onready var buttons = [
	$VBoxContainer/Button,
	$VBoxContainer/Button2,
	$VBoxContainer/Button3
]

var player
var health
var shoot
var orbit
var current_upgrades = []

func setup(player_node):
	print("SETUP CALLED")

	player = player_node

	health = player.get_node("HealthComponent")

	shoot = player.get_node("ShootComponent")
	
	orbit = player.get_node("OrbitComponent")

var possible_upgrades = [
	"+1 Ammo",
	"+1 Health",
	"-0.3s Reload",
	"+0.8 Invincibility",
	"-0.2s DashCooldown"
]

func _ready():

	button1.disabled = true
	button2.disabled = true
	button3.disabled = true
	
	randomize()
	var pool = possible_upgrades.duplicate()
	pool.shuffle()
	current_upgrades = pool.slice(0, 3)
	assign_buttons()

	enable_buttons()

func assign_buttons():

	for i in range(buttons.size()):

		var upgrade = current_upgrades[i]

		buttons[i].text = upgrade

		var icon = buttons[i].get_node("TextureRect")

		icon.texture = upgrade_icons[upgrade]

func enable_buttons():

	await get_tree().create_timer(0.8, true).timeout

	button1.disabled = false
	button2.disabled = false
	button3.disabled = false

func _on_button_pressed():
	apply_upgrade(current_upgrades[0])
	
func _on_button_2_pressed():
	apply_upgrade(current_upgrades[1])
	
func _on_button_3_pressed():
	apply_upgrade(current_upgrades[2])
	
func apply_upgrade(upgrade):

	match upgrade:

		"+1 Ammo":

			shoot.max_ammo += 1
			shoot.current_ammo += 1
			shoot.emit_signal("ammo_changed",shoot.current_ammo,shoot.max_ammo)


		"+1 Health":

			health.max_health += 1
			health.current_health += 1
			health.emit_signal("health_changed",health.current_health,health.max_health)

		"-0.3s Reload":

			shoot.reload_time -= 0.3

			shoot.reload_time = max(shoot.reload_time, 0.2)


		"+0.8 Invincibility":

			health.invincibility_time += 0.8

		"-0.2s DashCooldown":
			orbit.dash_cooldown -= 0.2
			orbit.dash_cooldown = max(orbit.dash_cooldown,0.3)


	get_tree().paused = false

	queue_free()
