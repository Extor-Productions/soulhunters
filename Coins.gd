extends Area2D

@export var coins_amount = 1

func change_coin_value(amount):
	coins_amount = amount

func _on_body_entered(body):
	#Sug till spelaren
	pass # Replace with function body.

func _on_delete_body_entered(body):
	Game.coins += coins_amount
	queue_free()
