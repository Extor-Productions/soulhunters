extends Area2D

#Hildings kod
@export var next_scene: PackedScene = preload("res://Worlds/Levels/World_1/world.tscn")

func _on_body_entered(body: CharacterBody2D):
	#Kolla om bodyn som arean känner av är spelaren
	if body.is_in_group("Player"):
		#Byt scene till next_scene
		GlobalSignals.emit_signal("change_scene", next_scene)
