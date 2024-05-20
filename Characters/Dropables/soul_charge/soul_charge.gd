extends CharacterBody2D

#Rasmus kod

@onready var gravity = 900

func _ready():
	$CPUParticles2D.emitting = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()

func _on_area_2d_body_entered(body):
	Game.souls += 1
	GlobalSignals.emit_signal("change_coin", Game.souls)
	queue_free()
