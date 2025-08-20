extends Node2D

var held
var plant = preload("res://scene/plant.tscn")

func _ready():
	pass
		
func harvest():
	Global.changeGold(1)
