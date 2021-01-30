extends Area2D

signal leaving_level

var exited = []

func _on_ExitDoor_body_entered(body):
	exited.append(body)
	if exited.size() >= 2:
		emit_signal("leaving_level")

func _on_ExitDoor_body_exited(body):
	exited.pop_back()
