extends Node2D

@onready var current_scene_node = $CurrentScene
@onready var start_screen = preload("res://Menus/main_meny.tscn")

func _ready():
	GlobalSignals.connect("change_scene", change_scene)
	GlobalSignals.connect("player_death", player_death)

func change_scene(next_scene: PackedScene):
	var new_scene = next_scene.instantiate()
	var old_scene = current_scene_node.get_child(0)
	
	current_scene_node.call_deferred("add_child", new_scene)
	current_scene_node.call_deferred("remove_child", old_scene)

func player_death():
	var new_start_screen = start_screen.instantiate()
	var old_scene = current_scene_node.get_child(0)
	
	Game.souls = 0
	
	current_scene_node.call_deferred("add_child", new_start_screen)
	current_scene_node.call_deferred("remove_child", old_scene)


