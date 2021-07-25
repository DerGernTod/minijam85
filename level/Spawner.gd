extends Position2D

enum Direction { LEFT = -1, RIGHT = 1 }

onready var _timer = $Timer
onready var _enemy_scene = preload("res://enemy/Enemy.tscn")

export(Direction) var direction

var _spawn_scale = 1 setget set_spawn_scale

func set_spawn_scale(spawn_scale: float) -> void:
	_spawn_scale = spawn_scale


func set_paused(paused: bool) -> void:
	_timer.paused = paused


func _ready() -> void:
	_timer.connect("timeout", self, "_on_timer_timeout")
	_timer.start(rand_range(5.0, 15.0))
	

func _on_timer_timeout() -> void:
	var enemy = _enemy_scene.instance()
	add_child(enemy)
	enemy.position = Vector2.ZERO
	enemy.scale = Vector2.ONE * _spawn_scale
	enemy.set_direction(direction)
	_timer.start(rand_range(5.0, 15.0))
