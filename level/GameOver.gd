extends Control

onready var _leave_button = $MarginContainer/CenterContainer/VBoxContainer/MarginContainer2/HBoxContainer/Leave
onready var _play_button = $MarginContainer/CenterContainer/VBoxContainer/MarginContainer2/HBoxContainer/Play

func show() -> void:
	modulate.a = 1
	_leave_button.disabled = false
	_play_button.disabled = false


func _ready() -> void:
	_leave_button.disabled = true
	_play_button.disabled = true
	modulate.a = 0


func _on_Leave_button_up() -> void:
	get_tree().paused = false
	get_tree().change_scene("res://Main.tscn")


func _on_Play_button_up() -> void:
	get_tree().paused = false
	get_tree().change_scene("res://level/Level.tscn")
