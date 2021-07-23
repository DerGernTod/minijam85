extends RigidBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.frame = randi() % sprite.frames.get_frame_count("default")
	apply_central_impulse(Vector2.UP * 500)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _physics_process(delta: float) -> void:
	var cols = get_colliding_bodies()
	for col in cols:
		if col is Player:
			col.collect_gold()
			queue_free()
	
