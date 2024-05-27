extends Node2D

@onready var text_parent = $Text
@onready var text_lable = $Text/RichTextLabel
@export var text: String

func _ready():
	text_lable.text = text

func _on_area_2d_area_entered(area):
	#Show sign
	text_parent.visible = true

func _on_area_2d_area_exited(area):
	#Hide sign
	text_parent.visible = false
