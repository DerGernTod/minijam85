extends Position2D

onready var _spawn_location = $SpawnLocation
onready var _init_inner_pos = _spawn_location.position
onready var _bubble_scene = preload("res://player/bubble/Bubble.tscn")

var direction = 0

func _ready() -> void:
	pass


func fire() -> void:
	var bubble = _bubble_scene.instance()
	$"/root".add_child(bubble)
	bubble.position = _spawn_location.global_position
	bubble.set_direction(direction)


func look_right(right: bool) -> void:
	if right:
		direction = 1
		_spawn_location.position.x = _init_inner_pos.x
	else:
		direction = -1
		_spawn_location.position.x = -_init_inner_pos.x
