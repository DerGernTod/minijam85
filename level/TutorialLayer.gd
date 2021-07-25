extends CanvasLayer

signal gold_collected
signal part_damaged

const TUTORIAL_STATES = [
	{ 
		"text": "Hahahaha! Finally my alchemist skills paid off. Behold! The "\
		+ "Gold Machine!\nHit <space> to continue.",
	},
	{ 
		"text": "It takes some time to produce gold. I should use <A> and "\
		+ "<D> to move and collect it!",
	},
	{ 
		"text": "I have good use for this gold. Better jump up with <W> and go "\
		+ "down with <S> to reach other parts of my machine!",
	},
	{
		"text": "Oh no, I see someone coming. I'm sure they're after my ideas "\
		+ "and gold. I have to fend them off with <K>!"
	},
	{ 
		"text": "They're ruining my machine! It won't be long until it breaks "\
		+ "apart. No one can tell what will happen then... It might even "\
		+ "distort reality itself!"
	},
	{ 
		"text": "Keeping it intact with <J> is crucial! I will need some gold "\
		+ "to create some spare parts though... Luckily my machine will still "\
		+ "produce some until all parts are broken."
	},
]

onready var _text_box = $MarginContainer/TextBox

func _ready() -> void:
	_start()
	
	
func _start() -> void:
	for spawner in get_tree().get_nodes_in_group("Spawners"):
		spawner.set_paused(true)
	get_tree().paused = true
	# intro
	yield(_text_box.play_text(TUTORIAL_STATES[0].text), "completed")
	
	# how to collect gold -> move with a and d
	yield(_text_box.play_text(TUTORIAL_STATES[1].text), "completed")
	_text_box.visible = false
	get_tree().paused = false
	yield(self, "gold_collected")
	_text_box.visible = true
	get_tree().paused = true
	
	# how to jump and drop -> reach vitals with jump
	yield(_text_box.play_text(TUTORIAL_STATES[2].text), "completed")
	_text_box.visible = false
	get_tree().paused = false
	yield(get_tree().create_timer(7), "timeout")
	_text_box.visible = true
	get_tree().paused = true
	
	# oh no they're coming!
	yield(_text_box.play_text(TUTORIAL_STATES[3].text), "completed")
	_text_box.visible = false
	get_tree().paused = false
	for spawner in get_tree().get_nodes_in_group("Spawners"):
		spawner.set_paused(false)
	for vital in get_tree().get_nodes_in_group("MachineVitals"):
		vital.connect("damaged", self, "_on_DamagablePart_damaged")
	yield(self, "part_damaged")
	_text_box.visible = true
	get_tree().paused = true
	
	# how to fight
	yield(_text_box.play_text(TUTORIAL_STATES[4].text), "completed")
	yield(_text_box.play_text(TUTORIAL_STATES[5].text), "completed")
	_text_box.visible = false
	get_tree().paused = false




func _on_Player_gold_updated(gold: int) -> void:
	emit_signal("gold_collected")


func _on_DamagablePart_damaged() -> void:
	emit_signal("part_damaged")
	for vital in get_tree().get_nodes_in_group("MachineVitals"):
		vital.disconnect("damaged", self, "_on_DamagablePart_damaged")
