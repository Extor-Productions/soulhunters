extends Path2D

class_name pathfinding_snail

var speed = 50
@onready var path_follow = $PathFollow2D
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	path_follow.progress += speed * delta
