extends RichTextLabel

onready var _tween = $Tween

var _scroll_queue_active = false
var _cur_line = 0

func _ready() -> void:
	show_text("They're coming!!")
	

func show_text(new_text: String) -> void:
	while _tween.is_active():
		yield(_tween, "tween_all_completed")
		yield(get_tree().create_timer(1.5), "timeout")
	newline()
	add_text(new_text)
	var prev_visible_characters = visible_characters
	_tween.interpolate_property(self,
		"visible_characters",
		prev_visible_characters,
		text.length(),
		0.5)
	_tween.start()

