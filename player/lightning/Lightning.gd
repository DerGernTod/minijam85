extends Area2D

onready var sprite = $Sprite
onready var init_sprite_scale = $Sprite.scale
onready var col_shape = $CollisionShape2D
onready var init_inner_pos = col_shape.position
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var prev_pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	prev_pos = global_position
	set_active(false)


func set_active(active: bool) -> void:
	set_physics_process(active)
	sprite.visible = active
	prev_pos = global_position


func _physics_process(delta: float) -> void:
	var dir = global_position - prev_pos
	var bodies = get_overlapping_bodies()
	for body in bodies:
		print(body.name)
	if dir.x > 5:
		col_shape.position.x = init_inner_pos.x
		sprite.position.x = init_inner_pos.x
		sprite.scale.x = init_sprite_scale.x
	if dir.x < -5:
		col_shape.position.x = -init_inner_pos.x
		sprite.position.x = -init_inner_pos.x
		sprite.scale.x = -init_sprite_scale.x
	prev_pos = global_position
