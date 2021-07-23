extends AnimatedSprite

signal timeout

const MAX_TIME = 10.0

var current_time = MAX_TIME

func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	current_time -= delta
	frame = int((MAX_TIME - current_time) * 8 / MAX_TIME)
	if current_time <= 0:
		frame = 0
		current_time = 0
		set_physics_process(false)
		emit_signal("timeout")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
