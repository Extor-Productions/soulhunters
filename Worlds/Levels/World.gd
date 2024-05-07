extends Node2D

func _ready():
	process_mode = Node.PROCESS_MODE_INHERIT


func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		if get_tree().paused == false:
			get_tree().paused = true
			print('funka?')
		elif get_tree().paused == true:
			get_tree().paused = false
	
