extends KinematicBody2D
class_name Player

const GRAVITY_SCALE = Globals.DEFAULT_GRAVITY_SCALE

signal repair_started
signal repair_completed

onready var gravity_vector : Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity_vector")
onready var gravity_magnitude : int = ProjectSettings.get_setting("physics/2d/default_gravity")
onready var sprite = $Sprite
onready var lightning = $Lightning
onready var init_sprite_scale = sprite.scale
onready var _init_layers = collision_mask

export var speed := 10.0
export var damping := 1.0
export var jump_power := 100.0

var velocity := Vector2.ZERO
var lightning_active := false
var can_use_repair = false setget _set_can_use_repair
var is_repairing = false
var _is_dropping = false

func _ready() -> void:
	pass
	

func _set_can_use_repair(can_use: bool) -> void:
	can_use_repair = can_use


func _trigger_lightning() -> void:
	lightning_active = true
	lightning.fire()
	yield(sprite, "animation_finished")
	lightning_active = false


func _repair() -> void:
	sprite.animation = "repair"
	is_repairing = true
	emit_signal("repair_started")
	yield(sprite, "animation_finished")
	emit_signal("repair_completed")
	is_repairing = false
	sprite.animation = "idle"


func _drop_down() -> void:
	if _is_dropping:
		return
	_is_dropping = true
	collision_mask = collision_mask - 1
	yield(get_tree().create_timer(0.5), "timeout")
	collision_mask = collision_mask + 1
	_is_dropping = false


func _physics_process(delta: float) -> void:
	if can_use_repair and is_on_floor() and Input.is_action_just_pressed("interact"):
		_repair()
	if is_repairing:
		velocity = Vector2.ZERO
		return

	if Input.is_action_pressed("ui_right"):
		velocity += Vector2.RIGHT * speed * delta
	if Input.is_action_pressed("ui_left"):
		velocity += Vector2.LEFT * speed * delta
	if is_on_floor() and Input.is_action_just_pressed("ui_select"):
		velocity.y -= jump_power
	if Input.is_action_just_pressed("shoot") and not lightning_active:
		if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
			sprite.animation = "walk_attack"
		else:
			sprite.animation = "attack"
		_trigger_lightning()
	if Input.is_action_just_pressed("ui_down") and position.y < 900:
		_drop_down()

	if not lightning_active:
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
		sprite.scale.x = init_sprite_scale.x
	if velocity.x < -4:
		lightning.look_right(false)
		sprite.scale.x = -init_sprite_scale.x

	velocity += gravity_vector * gravity_magnitude * GRAVITY_SCALE * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func collect_gold() -> void:
	pass
