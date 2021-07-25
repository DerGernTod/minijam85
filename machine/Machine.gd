extends Node2D

signal part_destroyed
signal all_parts_destroyed

onready var gold_spawn_location = $GoldSpawnLocation
onready var gold_scene = preload("res://gold/Gold.tscn")
onready var gold_clock = $Clock
onready var _audio = $AudioStreamPlayer

var num_living_parts = 0


func _ready() -> void:
	gold_clock.connect("timeout", self, "_spawn_gold")
	gold_clock.set_physics_process(true)
	for part in get_children():
		if part is DamagablePart:
			num_living_parts += 1
			part.connect("destroyed", self, "_on_part_destroyed")
			part.connect("repaired", self, "_on_part_repaired")
	_spawn_gold()


func _spawn_gold() -> void:
	_audio.play()
	for i in 5:
		var gold = gold_scene.instance()
		add_child(gold)
		gold.position = gold_spawn_location.position
		gold_clock.change_time(Globals.TIMER_DURATION)
		gold_clock.set_physics_process(true)
		yield(get_tree(), "idle_frame")


func _on_part_destroyed() -> void:
	num_living_parts -= 1
	emit_signal("part_destroyed")
	
	if num_living_parts <= 0:
		print("all parts destroyed")
		emit_signal("all_parts_destroyed")


func _on_part_repaired() -> void:
	num_living_parts += 1
