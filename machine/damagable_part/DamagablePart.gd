extends Area2D
class_name DamagablePart

signal destroyed

onready var clock = $Clock
onready var sprite = $AnimatedSprite

var player_body: Player = null

func _ready() -> void:
	connect("body_entered", self, "_body_entered")
	connect("body_exited", self, "_body_exited")
	clock.connect("timeout", self, "_clock_timed_out")
	clock.visible = false


func apply_damage() -> void:
	sprite.frame = max(sprite.frame, 1)
	clock.change_time(-1)
	clock.visible = true
	clock.set_physics_process(true)
	if player_body:
		player_body.can_use_repair = true


func _clock_timed_out() -> void:
	sprite.frame = 2
	emit_signal("destroyed")


func _body_entered(body: Node) -> void:
	if body is Player:
		body.connect("repair_started", self, "_repair_started")
		body.can_use_repair = true
		player_body = body


func _body_exited(body: Node) -> void:
	if body is Player:
		body.disconnect("repair_started", self, "_repair_started")
		body.can_use_repair = false
		player_body = null


func _repair_started() -> void:
	clock.set_physics_process(false)
	print("part repair started")
	# do repair stuff
	yield(player_body, "repair_completed")
	clock.set_physics_process(true)
	sprite.frame = 0
	clock.change_time(30.0)
	if clock.get_current_time() >= Globals.TIMER_DURATION:
		clock.visible = false

