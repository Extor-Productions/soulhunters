extends Node2D

@onready var collis = $StaticBody2D/CollisionShape2D

func _on_area_2d_body_entered(body):
	collis.call_deferred("set_disabled", true)


func _on_area_2d_2_body_entered(body):
	collis.call_deferred("set_disabled", false)
