class_name Pot extends Area2D

signal potting

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Pots")

func setPos(vec : Vector2):
	self.position = vec
