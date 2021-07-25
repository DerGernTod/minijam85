extends KinematicBody2D
class_name Player

const CONTROL_SCHEMES = {
	"default": {
		"left": "ui_left",
		"right": "ui_right",
		"jump": "ui_select",
		"drop": "ui_down",
		"shoot": "shoot",
		"interact": "interact",
	},
	"reversed_directions": {
		"left": "ui_right",
		"right": "ui_left",
		"jump": "ui_select",
		"drop": "ui_down",
		"shoot": "shoot",
		"interact": "interact",},
	"scrambled": {
		"left": "ui_right",
		"right": "ui_left",
		"jump": "ui_down",
		"drop": "ui_select",
		"shoot": "interact",
		"interact": "shoot",
	},
}

signal repair_started
signal repair_completed
signal gold_updated

onready var gravity_vector : Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity_vector")
onready var gravity_magnitude : int = ProjectSettings.get_setting("physics/2d/default_gravity")
onready var sprite = $Sprite
onready var lightning = $LightningWeapon
onready var bubbles = $BubbleWeapon
onready var init_sprite_scale = sprite.scale
onready var _init_layers = collision_mask
onready var _cur_weapon = lightning
onready var _audio = $AudioStreamPlayer2D
onready var _stream_repair = preload("res://player/repair.ogg")
onready var _stream_gold = preload("res://player/gold_collected.ogg")
onready var _stream_repair_invalid = preload("res://player/repair_invalid.ogg")

export var speed := 10.0
export var damping := 1.0
export var jump_power := 100.0

var velocity := Vector2.ZERO
var weapon_active := false
var can_use_repair = false setget _set_can_use_repair
var is_repairing = false
var _is_dropping = false
var _gravity_scale = Globals.DEFAULT_GRAVITY_SCALE setget set_gravity_scale, get_gravity_scale
var _control_scheme = "default" setget set_control_scheme
var _cur_gold_amount = 0

func get_gravity_scale() -> float:
	return _gravity_scale


func set_gravity_scale(g_scale: float) -> void:
	_gravity_scale = g_scale


func set_control_scheme(scheme: String) -> void:
	_control_scheme = scheme


func set_current_weapon(weapon: String) -> void:
	match weapon:
		"lightning":
			_cur_weapon = lightning
		"bubbles":
			_cur_weapon = bubbles


func collect_gold() -> void:
	_cur_gold_amount += 1
	emit_signal("gold_updated", _cur_gold_amount)
	_audio.stream = _stream_gold
	_audio.play()


func _ready() -> void:
	pass
	

func _set_can_use_repair(can_use: bool) -> void:
	can_use_repair = can_use


func _trigger_weapon() -> void:
	weapon_active = true
	_cur_weapon.fire()
	yield(sprite, "animation_finished")
	weapon_active = false


func _repair() -> void:
	if is_repairing:
		return
	if _cur_gold_amount <= 0:
		_audio.stream = _stream_repair_invalid
		_audio.play()
		return
	_cur_gold_amount -= 1
	emit_signal("gold_updated", _cur_gold_amount)

	sprite.animation = "repair"
	is_repairing = true
	emit_signal("repair_started")
	_play_repair_sounds()
	yield(sprite, "animation_finished")
	emit_signal("repair_completed")
	is_repairing = false
	sprite.animation = "idle"


func _play_repair_sounds() -> void:
	yield(get_tree().create_timer(1.0), "timeout")
	_audio.stream = _stream_repair
	_audio.play()
	yield(get_tree().create_timer(0.6), "timeout")
	_audio.play()
	yield(get_tree().create_timer(0.6), "timeout")
	_audio.play()
	yield(get_tree().create_timer(0.6), "timeout")
	_audio.play()

func _drop_down() -> void:
	if _is_dropping:
		return
	_is_dropping = true
	collision_mask = collision_mask ^ 1
	yield(get_tree().create_timer(0.25), "timeout")
	collision_mask = collision_mask | 1
	_is_dropping = false


func _control(val: String) -> String:
	return CONTROL_SCHEMES[_control_scheme][val]


func _physics_process(delta: float) -> void:
	if can_use_repair and is_on_floor() and Input.is_action_just_pressed(_control("interact")):
		_repair()
	if is_repairing:
		velocity = Vector2.ZERO
		return

	if Input.is_action_pressed(_control("right")):
		velocity += Vector2.RIGHT * speed * delta
	if Input.is_action_pressed(_control("left")):
		velocity += Vector2.LEFT * speed * delta
	if is_on_floor() and Input.is_action_just_pressed(_control("jump")):
		velocity.y -= jump_power
	if Input.is_action_just_pressed(_control("shoot")) and not weapon_active:
		if Input.is_action_pressed(_control("right")) or Input.is_action_pressed(_control("left")):
			sprite.animation = "walk_attack"
		else:
			sprite.animation = "attack"
		_trigger_weapon()
	if Input.is_action_just_pressed(_control("drop")) and position.y < 900:
		_drop_down()

	if not weapon_active:
		if not is_on_floor():
			if velocity.y > 350:
				sprite.animation = "fall"
			else:
				sprite.animation = "jump"
		else:
			if abs(velocity.x) > 50:
				sprite.animation = "walk"
			else:
				sprite.animation = "idle"
	
	velocity.x = lerp(velocity.x, 0, delta * damping)
	
	if velocity.x > 4:
		lightning.look_right(true)
		bubbles.look_right(true)
		sprite.scale.x = init_sprite_scale.x
	if velocity.x < -4:
		lightning.look_right(false)
		bubbles.look_right(false)
		sprite.scale.x = -init_sprite_scale.x

	velocity += gravity_vector * gravity_magnitude * _gravity_scale * delta
	velocity = move_and_slide(velocity, Vector2.UP)

