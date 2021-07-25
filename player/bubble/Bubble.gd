extends Area2D

const STATES = {
	"seeking": "_update_seeking",
	"leaving": "_update_leaving"
}

export(float) var speed = 200.0

onready var _start_height = position.y

var _cur_state = STATES.seeking
var _direction = 0


func set_direction(dir: int) -> void:
	_direction = dir


func _ready() -> void:
	connect("body_entered", self, "_body_entered")


func _physics_process(delta: float) -> void:
	call(_cur_state, delta)


func _update_seeking(delta: float) -> void:
	position.x += delta * speed
	position.y += sin(OS.get_ticks_msec() / 160)
	

func _update_leaving(delta: float) -> void:
	position.y -= delta * speed * 0.5
	position.x += sin(OS.get_ticks_msec() / 200)


func _body_entered(body: Node) -> void:
	if body is Enemy:
		disconnect("body_entered", self, "_body_entered")
		body.kill("bubble")
		_cur_state = STATES.leaving
		body.get_parent().remove_child(body)
		add_child(body)
		body.position = Vector2.ZERO
		
