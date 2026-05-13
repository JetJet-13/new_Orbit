extends Control

@onready var button1 = $VBoxContainer/Button
@onready var button2 = $VBoxContainer/Button2
@onready var button3 = $VBoxContainer/Button3

func on_continue_button_pressed():

	get_tree().paused = false

	queue_free()

func _ready():

	button1.disabled = true
	button2.disabled = true
	button3.disabled = true

	enable_buttons()
	
func enable_buttons():

	await get_tree().create_timer(0.8, true).timeout

	button1.disabled = false
	button2.disabled = false
	button3.disabled = false

func _on_button_pressed():
	on_continue_button_pressed()


func _on_button_2_pressed():
	on_continue_button_pressed()


func _on_button_3_pressed():
	on_continue_button_pressed()
