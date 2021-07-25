extends Area2D
class_name DamagablePart

signal destroyed
signal repaired
signal damaged

onready var clock = $Clock
onready var broken_sprite = $BrokenSprite
onready var working_sprite = $WorkingSprite
onready var _audio = $AudioStreamPlayer

var player_body: Player = null
var enemies = [];
var is_broken = false

func _ready() -> void:
	connect("body_entered", self, "_body_entered")
	connect("body_exited", self, "_body_exited")
	clock.connect("timeout", self, "_clock_timed_out")
	clock.visible = false

#
#func _process(delta: float) -> void:
#	if Input.is_action_just_pressed("shoot"):
#		_clock_timed_out()


func apply_damage() -> void:
	if is_broken:
		return
	emit_signal("damaged")
	clock.change_time(-1)
	clock.visible = true
	clock.set_physics_process(true)
	if player_body:
		player_body.can_use_repair = true


func _clock_timed_out() -> void:
	if is_broken:
		return
	_set_broken(true)
	emit_signal("destroyed")
	_audio.play(0)
	for enemy in enemies:
		enemy.part_destroyed()


func _set_broken(broken: bool) -> void:
	broken_sprite.visible = broken
	working_sprite.visible = not broken
	is_broken = broken

func _body_entered(body: Node) -> void:
	if body is Player:
		body.connect("repair_started", self, "_repair_started")
		body.part_reached()
		if clock.visible:
			body.can_use_repair = true
		player_body = body
	if body is Enemy and not is_broken:
		enemies.append(body)
		body.connect("dealt_damage", self, "apply_damage")
		body.connect("died", self, "_remove_enemy")
		body.part_reached()


func _remove_enemy(enemy: Enemy) -> void:
	var index = enemies.find(enemy)
	if index >= 0:
		enemies.remove(index)


func _body_exited(body: Node) -> void:
	if body is Player:
		body.disconnect("repair_started", self, "_repair_started")
		body.can_use_repair = false
		player_body = null
	if body is Enemy:
		if enemies.has(body):
			body.disconnect("dealt_damage", self, "apply_damage")
			_remove_enemy(body)


func _repair_started() -> void:
	player_body.can_use_repair = false
	clock.set_physics_process(false)
	yield(player_body, "repair_completed")
	clock.set_physics_process(true)
	
	if is_broken:
		emit_signal("repaired")
	
	clock.change_time(61.0)
	_set_broken(false)
	player_body.can_use_repair = true
	if clock.get_current_time() >= Globals.TIMER_DURATION:
		clock.visible = false
		player_body.can_use_repair = false

