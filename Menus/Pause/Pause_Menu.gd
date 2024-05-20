extends CanvasLayer   #måste skriva vem som gort vad rasmus har gjort

func _on_main_button_down():
	get_tree().paused = false # av pausar allt
	GlobalSignals.emit_signal("change_scene", preload("res://Menus/main_meny.tscn")) # byter scen till main menu



func _on_quit_button_down():
	get_tree().quit()    # lämna spell


func _on_options_button_down():
	visible = false
	
