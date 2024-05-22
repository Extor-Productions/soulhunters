extends Node2D
#Rasmus skriver den här koden
var In_Menu = -1

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS # kan inte pausa


func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		match In_Menu: # en avanserad and typ   ifall i menu åker du ut ifall i nåt annat back ett steg
			-1:
				get_tree().paused = true
				$"Pause Menu".visible = true
				In_Menu = 0
			0:
				get_tree().paused = false
				$"Pause Menu".visible = false
				In_Menu = -1
			1:
				$"Pause Menu".visible = true
				$Options_Menu.visible = false
				In_Menu = 0
			_:
				print("Error menu out of bounds")
	if event.is_action_pressed("Inventory"):1234



func _on_Main_menu_button_down():
	get_tree().paused = false # av pausar allt
	GlobalSignals.emit_signal("change_scene", preload("res://Menus/main_meny.tscn")) # byter scen till main menu



func _on_Quit_button_down():
	get_tree().quit()    # lämna spell

#options funka
func _on_Options_button_down():
	In_Menu = 1
	$"Pause Menu".visible = false
	$Options_Menu.visible = true
