extends KinematicBody2D
class_name Enemy

signal dealt_damage

const ATTACK_TIME = 5.0
const GRAVITY_SCALE = Globals.DEFAULT_GRAVITY_SCALE
const STATES = {
	"move": {
		"update": "_update_state_move",
		"part_reached": "_part_reached_state_move",
		"part_destroyed": "_noop",
	},
	"attack": {
		"update": "_update_state_attack",
		"part_reached": "_noop",
		"part_destroyed": "_part_destroyed_state_attack",
	},
}

export var speed := 5500
export var damping := 10.5

onready var gravity_vector : Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity_vector")
onready var gravity_magnitude : int = ProjectSettings.get_setting("physics/2d/default_gravity")

var _direction = 0
var _velocity = Vector2.ZERO
var _action_done = false
var _cur_attack_time = ATTACK_TIME
var _cur_state = STATES.move

func set_direction(dir: int) -> void:
	_direction = dir


func part_reached() -> void:
	call(_cur_state.part_reached)


func part_destroyed() -> void:
	call(_cur_state.part_destroyed)


func _noop() -> void:
	pass


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	call(_cur_state.update, delta)
	_velocity.x = lerp(_velocity.x, 0, delta * damping)
	_velocity = move_and_slide(_velocity, Vector2.UP)


func _update_state_move(delta: float) -> void:
	_velocity.x += speed * delta * _direction
	_velocity += gravity_vector * gravity_magnitude * GRAVITY_SCALE * delta


func _part_reached_state_move() -> void:
	if _action_done:
		return
	# let them run a bit more before stopping on the border of the damagable
	yield(get_tree().create_timer(0.5), "timeout")
	_cur_state = STATES.attack


func _update_state_attack(delta: float) -> void:
	_cur_attack_time -= delta
	if _cur_attack_time <= 0:
		_cur_attack_time = ATTACK_TIME
		emit_signal("dealt_damage")

	
func _part_destroyed_state_attack() -> void:
	_action_done = true;
	_cur_state = STATES.move


