extends Node2D

var pot = preload("res://scene/pot.tscn")
var locations = {
	Vector2(-144, -48) : false, 
	Vector2(0, -48) : false, 
	Vector2(144, -48) : false, 
	Vector2(-72, 48) : false,
	 Vector2(72, 48) : false,
}
# Called when the node enters the scene tree for the first time.
func _ready():
	makePots()
	for pots in get_children():
		if pots.is_in_group("Pots"):
			pots.placed.connect(potting)
			pots.unplaced.connect(unpotting)

func potting(place):
	locations[place.position] = true
	place.remGroup("Pots")

func unpotting(place):
	locations[place.position] = false
	place.setGroup("Pots")

func makePots():
	for i in locations.keys():
		var newPot = pot.instantiate()
		newPot.setGroup("Pots")
		newPot.setPos(i)
		add_child(newPot)
