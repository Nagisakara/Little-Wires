extends Control

@onready var seedGrid = $NinePatchRect/SeedSlots
@onready var itemGrid = $NinePatchRect/ItemSlots
var area : Area2D
var seedSlots : Array
var itemSlots : Array

func _ready():
	seedSlots = seedGrid.get_children()
	itemSlots = itemGrid.get_children()
	area = get_node("Area2D")
	area.setGroup("SellFront")

func setUpShop():
	var rng = RandomNumberGenerator.new()
	for i in seedSlots:
		var randkey = Global.ShopLoaded.wares[rng.rand_weighted(Global.ShopLoaded.probs)]
		while !(Global.getObj(randkey) is SeedData):
			randkey = Global.ShopLoaded.wares[rng.rand_weighted(Global.ShopLoaded.probs)]
		i.update(randkey)
	for i in itemSlots:
		var randkey = Global.ShopLoaded.wares[rng.rand_weighted(Global.ShopLoaded.probs)]
		while !(Global.getObj(randkey) is ItemData):
			randkey = Global.ShopLoaded.wares[rng.rand_weighted(Global.ShopLoaded.probs)]
		i.update(randkey)

func closeUpShop():
	for i in seedSlots:
		i.unUpdate()
	for i in itemSlots:
		i.unUpdate()
