extends Area2D

var player_body = null

func _ready() -> void:
	connect("body_entered", self, "_body_entered")
	connect("body_exited", self, "_body_exited")
	
	
func _body_entered(body: Node) -> void:
	if body is Player:
		body.connect("repair_started", self, "_repair_started")
		body.can_use_repair = true
		player_body = body


func _body_exited(body: Node) -> void:
	if body is Player:
		body.disconnect("repair_started", self, "_repair_started")
		body.can_use_repair = false
		player_body = null


func _repair_started() -> void:
	print("part repair started")
	# do repair stuff
	yield(player_body, "repair_completed")
	# do other repair stuff
	print("part repair completed")

