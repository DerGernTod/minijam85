extends Control

onready var _leave_button = $MarginContainer/CenterContainer/VBoxContainer/MarginContainer2/HBoxContainer/Leave
onready var _play_button = $MarginContainer/CenterContainer/VBoxContainer/MarginContainer2/HBoxContainer/Play
onready var _gold_collected_label = $MarginContainer/CenterContainer/VBoxContainer/GoldCollected/GoldAmount
onready var _gold_lost_label = $MarginContainer/CenterContainer/VBoxContainer/GoldLost/GoldLostAmount
onready var _enemies_bubbled_label = $MarginContainer/CenterContainer/VBoxContainer/EnemiesBubbled/EnemiesBubbledAmount
onready var _enemies_burned_label = $MarginContainer/CenterContainer/VBoxContainer/EnemiesBurned/EnemiesBurnedAmount
onready var _enemies_electrocuted_label = $MarginContainer/CenterContainer/VBoxContainer/EnemiesElectrocuted/EnemiesElectrocutedAmount

func show() -> void:
	_gold_collected_label.text = str(Globals.get_stat("gold_collected"))
	_gold_lost_label.text = str(Globals.get_stat("gold_lost"))
	_enemies_bubbled_label.text = str(Globals.get_stat("bubbles"))
	_enemies_burned_label.text = str(Globals.get_stat("fire"))
	_enemies_electrocuted_label.text = str(Globals.get_stat("lightning"))

	get_tree().paused = true
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
