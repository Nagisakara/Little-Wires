extends Node2D

var area : Area2D
var sell : Control
# Called when the node enters the scene tree for the first time.
func _ready():
	area = get_node("Area2D")
	area.setGroup("Shop")
	sell = get_node("SellFront")
	area.placed.connect(place)
	area.unplaced.connect(unplace)
	sell.setUpShop()

func place():
	pass

func unplace():
	pass
