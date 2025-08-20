extends Node2D

var sellbox : Area2D
var buybox : Area2D
var commit : Button
var sell : Control
var goldDiff := 0

var items : Array = []
var purchaseList : Array = []

func _ready():
	sellbox = get_node("SellBox")
	sellbox.setGroup("Selling")
	buybox = get_node("BuyBox")
	buybox.setGroup("Purchasing")
	sell = get_node("SellFront")
	commit = get_node("CommitButton")
	buybox.placed.connect(buyPlace)
	buybox.unplaced.connect(buyUnplace)
	sellbox.placed.connect(sellPlace)
	sellbox.unplaced.connect(sellUnplace)
	commit.pressed.connect(purchase)
	sell.setUpShop()

#Add to Counter
func sellPlace(_what, obj):
	items.append(obj)
	goldDiff += getObj(obj).price

func sellUnplace(_what, obj):
	items.erase(obj)
	goldDiff -= getObj(obj).price

#Subtract from Counter
func buyPlace(_what, obj):
	var newObj = getObj(obj)
	items.append(obj)
	goldDiff -= newObj.price
	purchaseList.append(newObj.name)

func buyUnplace(_what, obj):
	items.erase(obj)
	var newObj = getObj(obj)
	purchaseList.erase(newObj.name)
	goldDiff += getObj(obj).price

func purchase():
	var newGold = Global.getGold() + goldDiff
	if newGold < 0:
		print("Lack of Funds")
		return
	Global.changeGold(goldDiff)
	for i in items:
		i.queue_free()
	items.clear()
	for i in purchaseList:
		Global.addObj(i)
	purchaseList.clear()
	goldDiff = 0
	sell.closeUpShop()
	sell.setUpShop()

func getObj(obj):
	if "plantName" in obj:
		return Global.getItem(obj.plantName)
	elif "seedName" in obj:
		return Global.getSeed(obj.seedName)