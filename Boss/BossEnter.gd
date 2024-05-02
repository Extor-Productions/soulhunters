extends Area2D

@export var next_boss_scene: PackedScene

func _on_body_entered(body: CharacterBody2D):
	if body.is_in_group("Player"):
		get_tree().change_scene_to_packed(next_boss_scene)
