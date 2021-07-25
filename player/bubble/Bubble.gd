extends Area2D

const STATES = {
	"seeking": "_update_seeking",
	"leaving": "_update_leaving"
}

export(float) var speed = 200.0

onready var _start_height = position.y
onready var _enemy_sprite = $EnemySprite
onready var _visibility_notifier = $VisibilityNotifier2D

var _cur_state = STATES.seeking
var _direction = 0
var _random_offset = randi()


func set_direction(dir: int) -> void:
	_direction = dir


func _ready() -> void:
	connect("body_entered", self, "_body_entered")
	_visibility_notifier.connect("screen_exited", self, "queue_free")


func _physics_process(delta: float) -> void:
	call(_cur_state, delta)


func _update_seeking(delta: float) -> void:
	position.x += delta * speed * _direction
	position.y += sin(_random_offset + OS.get_ticks_msec() / 160.0)
	

func _update_leaving(delta: float) -> void:
	position.y -= delta * speed * 0.5
	position.x += sin(_random_offset + OS.get_ticks_msec() / 200.0)
	_enemy_sprite.rotate(delta)


func _body_entered(body: Node) -> void:
	if body is Enemy:
		disconnect("body_entered", self, "_body_entered")
		body.kill("bubble")
		_cur_state = STATES.leaving
		_enemy_sprite.visible = true
		
