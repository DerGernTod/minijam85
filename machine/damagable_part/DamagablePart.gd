extends Area2D
class_name DamagablePart

signal destroyed
signal repaired

onready var clock = $Clock
onready var sprite = $AnimatedSprite

var player_body: Player = null
var enemies = [];

func _ready() -> void:
	connect("body_entered", self, "_body_entered")
	connect("body_exited", self, "_body_exited")
	clock.connect("timeout", self, "_clock_timed_out")
	clock.visible = false


func apply_damage() -> void:
	if sprite.frame == 2:
		return
	sprite.frame = max(sprite.frame, 1)
	clock.change_time(-1)
	clock.visible = true
	clock.set_physics_process(true)
	if player_body:
		player_body.can_use_repair = true


func _clock_timed_out() -> void:
	if sprite.frame == 2:
		return
	
	sprite.frame = 2
	emit_signal("destroyed")
	for enemy in enemies:
		enemy.part_destroyed()


func _body_entered(body: Node) -> void:
	if body is Player:
		body.connect("repair_started", self, "_repair_started")
		if sprite.frame != 0:
			body.can_use_repair = true
		player_body = body
	if body is Enemy and sprite.frame != 2:
		enemies.append(body)
		body.connect("dealt_damage", self, "apply_damage")
		body.part_reached()


func _body_exited(body: Node) -> void:
	if body is Player:
		body.disconnect("repair_started", self, "_repair_started")
		body.can_use_repair = false
		player_body = null
	if body is Enemy:
		body.disconnect("dealt_damage", self, "apply_damage")
		enemies.remove(enemies.find(body))


func _repair_started() -> void:
	clock.set_physics_process(false)
	yield(player_body, "repair_completed")
	clock.set_physics_process(true)
	
	if sprite.frame == 2:
		emit_signal("repaired")
	
	sprite.frame = 0
	
	clock.change_time(30.0)
	if clock.get_current_time() >= Globals.TIMER_DURATION:
		clock.visible = false

