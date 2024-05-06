extends Node2D

var number_of_classes = 1

#vilken klass den visar
func show_class():
	
	if Game._class ==  0:
		
		$Character.play("Warior")
	
	elif Game._class == 1:
		
		$Character.play("wizard")

#byter charaktär
func _on_selection_arrow_left_pressed():
	
	Game._class -= 1
	
	if Game._class < 0:
		Game._class = number_of_classes
	
	show_class()

#byter karaktär
func _on_selection_arrow_right_pressed():
	
	Game._class += 1
	
	if Game._class > number_of_classes:
		
		Game._class = 0
	
	show_class()

#startar
func _on_ready_pressed():
	get_tree().change_scene_to_file("res://Worlds/world.tscn")
