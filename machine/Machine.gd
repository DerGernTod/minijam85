extends Node2D

onready var gold_spawn_location = $GoldSpawnLocation
onready var gold_scene = preload("res://gold_bar/GoldBar.tscn")
onready var gold_timer = $GoldTimer


func _ready() -> void:
	gold_timer.wait_time = Globals.TIMER_DURATION
	gold_timer.connect("timeout", self, "_spawn_gold")


func _spawn_gold() -> void:
	print("trying to spawn gold")
	var gold = gold_scene.instance()
	add_child(gold)
	gold.position = gold_spawn_location.position
