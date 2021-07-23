extends Node2D

onready var gold_spawn_location = $GoldSpawnLocation
onready var gold_scene = preload("res://gold_bar/GoldBar.tscn")

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var gold = gold_scene.instance()
		add_child(gold)
		gold.position = gold_spawn_location.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
