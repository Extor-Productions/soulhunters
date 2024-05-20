extends Node2D
class_name Pause

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		if get_tree().paused == false:
			get_tree().paused = true
			$"Pause Menu".visible = true
		elif get_tree().paused == true:
			get_tree().paused = false
			$"Pause Menu".visible = false


func _on_Main_menu_button_down():
	get_tree().paused = false # av pausar allt
	GlobalSignals.emit_signal("change_scene", preload("res://Menus/main_meny.tscn")) # byter scen till main menu



func _on_Quit_button_down():
	get_tree().quit()    # lämna spell


func _on_Options_button_down():
	visible = false
	
