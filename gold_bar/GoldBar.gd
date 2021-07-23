extends RigidBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apply_impulse(Vector2.RIGHT * 50, Vector2.UP * 500)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _physics_process(delta: float) -> void:
	var cols = get_colliding_bodies()
	for col in cols:
		if col is Player:
			col.collect_gold()
			queue_free()
	
