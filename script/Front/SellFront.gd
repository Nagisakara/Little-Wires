extends Control

@onready var seedGrid = $NinePatchRect/SeedSlots
@onready var itemGrid = $NinePatchRect/ItemSlots
var seedSlots : Array
var itemSlots : Array

func _ready():
	seedSlots = seedGrid.get_children()
	itemSlots = itemGrid.get_children()

func setUpShop():
	for i in seedSlots:
		var randkey = Global.SeedDatabase.keys().pick_random()
		i.seedUpdate(randkey)
	for i in itemSlots:
		var randkey = Global.ItemDatabase.keys().pick_random()
		i.itemUpdate(randkey)