extends Path2D

class_name pathfinding_snail

var speed = 50
@onready var path_follow = $PathFollow2D

func _ready():
	path_follow.get_child(0).connect("knockback", _knockback)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	path_follow.progress += speed * delta
	
	

func _knockback(korv):
	if korv:
		speed = 0
	else:
		speed = 50
