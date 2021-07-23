extends AnimatedSprite

signal timeout

const MAX_TIME = Globals.TIMER_DURATION

var current_time = MAX_TIME setget ,get_current_time

func _ready() -> void:
	set_physics_process(false)
	

func get_current_time() -> float:
	return current_time


func change_time(time: float) -> void:
	if current_time + time >= MAX_TIME:
		set_physics_process(false)
	current_time = clamp(current_time + time, 0, MAX_TIME)
	# update frame even if physics process is false
	_physics_process(0)


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
