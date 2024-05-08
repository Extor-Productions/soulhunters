extends Node2D

@onready var current_scene_node = $CurrentScene

func _ready():
	GlobalSignals.connect("change_scene", change_scene)

func change_scene(next_scene: PackedScene):
	var new_scene = next_scene.instantiate()
	var old_scene = current_scene_node.get_child(0)
	
	current_scene_node.call_deferred("add_child", new_scene)
	current_scene_node.call_deferred("remove_child", old_scene)
