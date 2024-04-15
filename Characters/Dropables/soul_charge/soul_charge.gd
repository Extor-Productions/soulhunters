extends CharacterBody2D

@onready var gravity = 5


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()

func _on_area_2d_body_entered(body):
	Game.souls += 1
	queue_free()
