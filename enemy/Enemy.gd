extends KinematicBody2D

const STATES = {
	"move_to_target": {
		"update": "_update_state_move_to_target",
		"complete": "_complete_state_move_to_target",
	},
	"manipulate_machine": {
		"update": "_update_state_manipulate_machine",
		"complete": "_complete_state_manipulate_machine",
	},
}
var cur_state = STATES.move_to_target.update

func _update_state_move_to_target(delta: float) -> void:
	pass
	
	
func _complete_state_move_to_target() -> void:
	cur_state = STATES.manipulate_machine.update


func _update_state_manipulate_machine(delta: float) -> void:
	pass

	
func _complete_state_manipulate_machine() -> void:
	# search new target, then switch state
	cur_state = STATES.move_to_target.update


func _ready() -> void:
	# chose one of tree's enemy paths
	pass
