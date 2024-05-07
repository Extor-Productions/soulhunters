extends Node2D

func _on_start_pressed():
	GlobalSignals.emit_signal("change_scene", preload("res://Menus/character_select_screen.tscn"))
	#get_tree().change_scene_to_file("res://Menus/character_select_screen.tscn")


func _on_quit_pressed():
	get_tree().quit()
