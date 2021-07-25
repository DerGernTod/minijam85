extends Node

var _started = false

onready var _player = $PlayerSprite
onready var _machine = $MachineTexture
onready var _tween = $Tween
onready var _container = $MarginContainer

func _ready() -> void:
	pass
	

func _process(delta: float) -> void:
	if Input.is_action_just_released("ui_select"):
		_start()


func _start() -> void:
	if _started:
		return
	_tween.interpolate_method(self, "_lerp_alpha", 1.0, 0.0, 1.0)
	_tween.interpolate_method(self, "_lerp_machine", _machine.modulate, Color.white, 1.0)
	_tween.start()
	yield(_tween, "tween_completed")
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().change_scene("res://level/Level.tscn")
	

func _lerp_alpha(alpha: float) -> void:
	_player.modulate.a = alpha
	_container.modulate.a = alpha
	

func _lerp_machine(mod: Color) -> void:
	_machine.modulate = mod
	
