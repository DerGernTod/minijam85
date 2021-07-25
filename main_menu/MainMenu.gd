extends Node

var _started = false

onready var _player = $PlayerSprite
onready var _machine = $MachineTexture
onready var _tween = $Tween
onready var _heading = $MarginContainer/VBoxContainer/HeadingLabel
onready var _play_label = $MarginContainer/VBoxContainer/PlayLabel
onready var _attribution = $Attribution
onready var _audio = $AudioStreamPlayer

func _ready() -> void:
	pass
	

func _process(delta: float) -> void:
	if Input.is_action_just_released("ui_select"):
		_start()


func _start() -> void:
	if _started:
		return
	_audio.play()
	_tween.interpolate_method(self, "_lerp_alpha", 1.0, 0.0, 1.0)
	
	_tween.interpolate_method(self, "_lerp_machine", _machine.modulate, Color.white, 1.0)
	_tween.start()
	_tween.interpolate_method(self, "_lerp_alpha_play_label", 20, 1, 1)
	yield(_tween, "tween_all_completed")
	_tween.interpolate_method(self, "_hide_play_label", 1, 0, 0.5)
	_tween.start()
	yield(get_tree().create_timer(0.75), "timeout")
	get_tree().change_scene("res://level/LevelTutorial.tscn")


func _hide_play_label(alpha: float) -> void:
	_play_label.modulate.a = 0	

	
func _lerp_alpha_play_label(alpha: int) -> void:
	_play_label.modulate.a = 0 if alpha % 2 == 0 else 1


func _lerp_alpha(alpha: float) -> void:
	_player.modulate.a = alpha
	_heading.modulate.a = alpha
	_attribution.modulate.a = alpha
	

func _lerp_machine(mod: Color) -> void:
	_machine.modulate = mod
	
