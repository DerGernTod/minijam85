extends Node

const TIMER_DURATION = 10.0

const DEFAULT_GRAVITY_SCALE = 15.0
const DEFAULT_PLAYER_SIZE = 1.0
const DEFAULT_ENEMY_SIZE = 1.0

var _stats = {}

func reset_stats() -> void:
	_stats = {
		"gold_collected": 0,
		"gold_lost": 0,
		"lightning": 0,
		"bubble": 0,
		"fire": 0,
	}
	
	
func increment_stat(stat: String) -> void:
	_stats[stat] += 1
	
	
func get_stat(stat: String) -> int:
	return _stats[stat]
