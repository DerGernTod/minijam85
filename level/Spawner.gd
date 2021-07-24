extends Position2D

onready var _timer = $Timer
onready var _enemy_scene = preload("res://enemy/Enemy.tscn")

enum Direction { LEFT = -1, RIGHT = 1 }
export(Direction) var direction

func _ready() -> void:
	_timer.wait_time = rand_range(5.0, 15.0)
	_timer.connect("timeout", self, "_on_timer_timeout")
	

func _on_timer_timeout() -> void:
	var enemy = _enemy_scene.instance()
	add_child(enemy)
	enemy.position = Vector2.ZERO
	enemy.set_direction(direction)
	_timer.wait_time = rand_range(5.0, 15.0)
