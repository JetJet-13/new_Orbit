extends Area2D   # ✅ FIXED

@export var speed = 250.0
var direction: Vector2 = Vector2.ZERO
@export var lifetime := 3.0
var time_alive := 0.0

var is_enemy_bullet = true
var can_be_destroyed_by_bullets = true

@onready var sprite = get_node_or_null("Sprite2D")

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))

func _process(delta):
	time_alive += delta
	if time_alive >= lifetime:
		queue_free()

	global_position += direction * speed * delta

	if direction != Vector2.ZERO:
		rotation = direction.angle() + PI / 2


func _on_area_entered(area):
	# only interact with bullets
	if not area.is_in_group("bullet"):
		return

	# ignore same type
	if area.is_in_group("enemy_bullet"):
		return

	# cancel bullets
	queue_free()
	area.queue_free()
	
func set_bullet_texture(new_texture):
	if sprite:
		sprite.texture = new_texture
