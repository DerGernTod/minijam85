extends Area2D

onready var sprite = $Sprite
onready var init_sprite_scale = $Sprite.scale
onready var col_shape = $CollisionShape2D
onready var init_inner_pos = col_shape.position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_active(false)


func look_right(right: bool) -> void:
	if right:
		col_shape.position.x = init_inner_pos.x
		sprite.position.x = init_inner_pos.x
		sprite.scale.x = init_sprite_scale.x

	else:
		col_shape.position.x = -init_inner_pos.x
		sprite.position.x = -init_inner_pos.x
		sprite.scale.x = -init_sprite_scale.x


func set_active(active: bool) -> void:
	set_physics_process(active)
	sprite.visible = active


func _physics_process(delta: float) -> void:
	var bodies = get_overlapping_bodies()
	var areas = get_overlapping_areas()
	for body in bodies:
		# todo: check for enemies
		pass
	for area in areas:
		if area is DamagablePart:
			area.apply_damage()
		
