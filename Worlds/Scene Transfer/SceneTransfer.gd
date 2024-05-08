extends Area2D

@export var next_scene: PackedScene

func _on_body_entered(body: CharacterBody2D):
	if body.is_in_group("Player"):
		GlobalSignals.emit_signal("change_scene", next_scene)
