extends RichTextLabel

var text_running = false

onready var _tween = $Tween

func _ready() -> void:
	pass
	#show_text("They're coming!!")
	

func show_text(new_text: String) -> void:
	while text_running:
		yield(get_tree(), "idle_frame")
	text_running = true
	get_parent().visible = true
	print("text length: %s, visible chars: %s" % [text.length(), visible_characters])
	newline()
	add_text(new_text)
	_tween.interpolate_property(self,
		"visible_characters",
		null,
		text.length() - get_line_count() + 1,
		0.5)
	_tween.start()
	yield(_tween, "tween_completed")
	yield(get_tree().create_timer(1.5), "timeout")
	get_parent().visible = false
	text_running = false
	

