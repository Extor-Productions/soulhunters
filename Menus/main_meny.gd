extends Node2D

#Hildings kod
func _on_start_pressed():
	GlobalSignals.emit_signal("change_scene", preload("res://Menus/character_select_screen.tscn"))

#Rasmus kod
func _on_quit_pressed():
	get_tree().quit()
