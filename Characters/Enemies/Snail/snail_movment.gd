extends Path2D
class_name pathfinding_snail

#Rasmus kod

var speed = 50
@onready var path_follow = $PathFollow2D

func _ready():
	#Connect signalen från signalen till denna skript
	path_follow.get_child(0).connect("knockback", _knockback)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	path_follow.progress += speed * delta

func _knockback(knockback, dir):
	if knockback:
		speed = 70 * dir
		if speed > 0:
			speed = speed * 2
	else:
		speed = 50
