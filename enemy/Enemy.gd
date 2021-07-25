extends KinematicBody2D
class_name Enemy

signal dealt_damage
signal died

const GRAVITY_SCALE = Globals.DEFAULT_GRAVITY_SCALE
const DEATH_TIMERS = {
	"lightning": 1.0,
	"bubble": 0.0,
}
const STATES = {
	"move": {
		"update": "_update_state_move",
		"part_reached": "_part_reached_state_move",
		"part_destroyed": "",
		"gold_collected": "_gold_collected_state_move",
	},
	"attack": {
		"update": "_noop_arg",
		"part_reached": "",
		"part_destroyed": "_part_destroyed_state_attack",
		"gold_collected": "",
	},
	"die": {
		"update": "_noop_arg",
		"part_reached": "",
		"part_destroyed": "",
		"gold_collected": "",
	},
}

export var speed := 5500
export var damping := 10.5

onready var gravity_vector : Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity_vector")
onready var gravity_magnitude : int = ProjectSettings.get_setting("physics/2d/default_gravity")
onready var _sprite = $Sprite
onready var _init_sprite_scale = _sprite.scale
onready var _state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")
onready var _audio = $AudioStreamPlayer2D
onready var _attack_stream = preload("res://enemy/machine_hit_2.ogg")
onready var _death_lightning_stream = preload("res://enemy/death_lightning.ogg")

var _direction = 0
var _velocity = Vector2.ZERO
var _action_done = false
var _cur_state = STATES.move


func set_direction(dir: int) -> void:
	_direction = dir
	_sprite.scale.x = _init_sprite_scale.x * dir


func part_reached() -> void:
	if has_method(_cur_state.part_reached):
		call(_cur_state.part_reached)


func part_destroyed() -> void:
	if has_method(_cur_state.part_destroyed):
		call(_cur_state.part_destroyed)


func collect_gold() -> void:
	if has_method(_cur_state.gold_collected):
		call(_cur_state.gold_collected)
	

func kill(death_type: String) -> void:
	if _cur_state == STATES.die:
		return
	collision_layer = 0
	collision_mask = 0
	set_physics_process(false)
	_state_machine.travel("death_%s" % death_type)
	emit_signal("died", self)
	_cur_state = STATES.die
	Globals.increment_stat(death_type)
	if death_type == "lightning":
		_audio.stream = _death_lightning_stream
		_audio.play()
	# play and wait for death animation
	yield(get_tree().create_timer(DEATH_TIMERS[death_type]), "timeout")
	if _audio.playing:
		yield(_audio, "finished")
	queue_free()


func _noop() -> void:
	pass


func _noop_arg(delta: float) -> void:
	pass


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	call(_cur_state.update, delta)
	_velocity.x = lerp(_velocity.x, 0, delta * damping)	
	_velocity += gravity_vector * gravity_magnitude * GRAVITY_SCALE * delta
	_velocity = move_and_slide(_velocity, Vector2.UP)


func _update_state_move(delta: float) -> void:
	if is_on_floor():
		_velocity.x += speed * delta * _direction

	if (_direction < 0 and global_position.x < -20)\
		or (_direction > 0 and global_position.x > 1940):
			queue_free()


func _part_reached_state_move() -> void:
	if _action_done:
		return
	# let them run a bit more before stopping on the border of the damagable
	yield(get_tree().create_timer(rand_range(0.1, 0.3)), "timeout")
	_state_machine.travel("attack")
	
	_cur_state = STATES.attack


func _gold_collected_state_move() -> void:
	var prev_dir = _direction
	_direction = 0
	_action_done = true
	collision_mask = collision_mask ^ 8
	# wait for yay! animation
	yield(get_tree().create_timer(1), "timeout")
	_direction = prev_dir


func execute_attack() -> void:
	emit_signal("dealt_damage")
	_audio.stream = _attack_stream
	_audio.play(0)

	
func _part_destroyed_state_attack() -> void:
	_action_done = true
	_state_machine.travel("walk")
	_cur_state = STATES.move


