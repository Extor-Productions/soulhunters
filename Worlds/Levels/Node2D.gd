extends Node2D



func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		if get_tree().paused == false:
			get_tree().paused = true
			$CanvasLayer.visible = true
		elif get_tree().paused == true:
			get_tree().paused = false
			$CanvasLayer.visible = false
	
