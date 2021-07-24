extends Node2D

const EFFECTS = {
	"player_gravity_scale": [
		Globals.DEFAULT_GRAVITY_SCALE,
		Globals.DEFAULT_GRAVITY_SCALE - 5.0,
		Globals.DEFAULT_GRAVITY_SCALE - 8.0,
	],
	"weapon": ["lightning", "fire", "bubbles"],
	"player_size": [
		Globals.DEFAULT_PLAYER_SIZE - 0.5, 
		Globals.DEFAULT_PLAYER_SIZE, 
		Globals.DEFAULT_PLAYER_SIZE + 0.5,
		Globals.DEFAULT_PLAYER_SIZE + 1.0,
	],
	"enemy_size": [
		Globals.DEFAULT_ENEMY_SIZE - 0.5, 
		Globals.DEFAULT_ENEMY_SIZE, 
		Globals.DEFAULT_ENEMY_SIZE + 0.5,
		Globals.DEFAULT_ENEMY_SIZE + 1.0,
	],
#	"color": [],
	"controls": ["default", "reversed_directions", "scrambled"],
}

var cur_effects = {
	"player_gravity_scale": Globals.DEFAULT_GRAVITY_SCALE,
	"weapon": "lightning",
	"player_size": Globals.DEFAULT_PLAYER_SIZE,
	"enemy_size": Globals.DEFAULT_ENEMY_SIZE,
#	"color": [],
	"controls": "default",
}

onready var player = $Player


func _ready() -> void:
	pass


#func _process(delta: float) -> void:
#	pass


func _on_Machine_part_destroyed():
	print("part destroyed, choose effect")
	var effect_keys = EFFECTS.keys()
	var effect_key = effect_keys[randi() % effect_keys.size()]
	var effect_values = EFFECTS[effect_key]
	
	var new_effect = effect_values[randi() % effect_values.size()]
	
	while new_effect == cur_effects[effect_key]:
		new_effect = effect_values[randi() % effect_values.size()]
	
	cur_effects[effect_key] = new_effect
	call("change_%s" % effect_key, new_effect)


func change_player_gravity_scale(gravity_scale: float) -> void:
	print("changing gravity scale to: %s" % gravity_scale)


func change_weapon(weapon: String) -> void:
	print("changing weapon to: %s" % weapon)


func change_player_size(player_size: float) -> void:
	print("changing player size to: %s" % player_size)


func change_enemy_size(enemy_size: float) -> void:
	print("changing enemy size to: %s" % enemy_size)


func change_controls(controls: String) -> void:
	print("changing controls to: %s" % controls)