extends Node2D

var held
var plant = preload("res://scene/plant.tscn")

func _ready():
	Global.purchase.connect(buyPot)
	Global.addItem("Brown Planter")
	Global.addSeed("Brown Seed")

func buyPot():
	var newPlant = plant.instantiate()
	newPlant.plucked.connect(harvest)
	add_child(newPlant)
		
func harvest():
	Global.changeGold(1)
