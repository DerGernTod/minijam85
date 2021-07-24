extends Node2D

signal part_destroyed

onready var gold_spawn_location = $GoldSpawnLocation
onready var gold_scene = preload("res://gold/Gold.tscn")
onready var gold_clock = $Clock


func _ready() -> void:
	gold_clock.connect("timeout", self, "_spawn_gold")
	gold_clock.set_physics_process(true)
	for part in get_children():
		if part is DamagablePart:
			part.connect("destroyed", self, "_on_part_destroyed")


func _spawn_gold() -> void:
	var gold = gold_scene.instance()
	add_child(gold)
	gold.position = gold_spawn_location.position
	gold_clock.change_time(Globals.TIMER_DURATION)
	gold_clock.set_physics_process(true)


func _on_part_destroyed() -> void:
	emit_signal("part_destroyed")
