extends KinematicBody2D
class_name Player

const GRAVITY_SCALE = 15.0

onready var gravity_vector : Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity_vector")
onready var gravity_magnitude : int = ProjectSettings.get_setting("physics/2d/default_gravity")

export var speed := 10.0
export var damping := 1.0
export var jump_power := 100.0

var velocity := Vector2.ZERO

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		velocity += Vector2.RIGHT * speed * delta
	if Input.is_action_pressed("ui_left"):
		velocity += Vector2.LEFT * speed * delta
	if is_on_floor() and Input.is_action_just_pressed("ui_select"):
		velocity.y -= jump_power
	
	velocity.x = lerp(velocity.x, 0, delta * damping)
	velocity += gravity_vector * gravity_magnitude * GRAVITY_SCALE * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func collect_gold() -> void:
	pass
