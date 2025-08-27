extends Node2D

@onready var sellbox : Area2D = $SellBox
@onready var buybox : Area2D = $BuyBox
@onready var commit : Button = $CommitButton
@onready var label : Label = $Label
@onready var sell : Control = $SellFront
var goldDiff := 0

var items : Array = []
var purchaseList : Array = []

func _ready():
	sellbox.setGroup("Selling")
	buybox.setGroup("Purchasing")
	buybox.placed.connect(buyPlace)
	buybox.unplaced.connect(buyUnplace)
	sellbox.placed.connect(sellPlace)
	sellbox.unplaced.connect(sellUnplace)
	commit.pressed.connect(purchase)
	sell.setUpShop()
	label.text = ""

func setLabel():
	if goldDiff > 0:
		label.text = "Gains "
	elif goldDiff < 0:
		label.text = "Costs "
	else:
		if items.is_empty():
			label.text = ""
			return
		label.text = "Breaks Even"
		return
	label.text += str(abs(goldDiff))
	label.text += "\nGold"

#Add to Counter
func sellPlace(_what, obj):
	items.append(obj)
	goldDiff += getObj(obj).price
	setLabel()

func sellUnplace(_what, obj):
	items.erase(obj)
	goldDiff -= getObj(obj).price
	setLabel()

#Subtract from Counter
func buyPlace(_what, obj):
	var newObj = getObj(obj)
	items.append(obj)
	goldDiff -= newObj.price
	purchaseList.append(newObj.name)
	setLabel()

func buyUnplace(_what, obj):
	items.erase(obj)
	var newObj = getObj(obj)
	purchaseList.erase(newObj.name)
	goldDiff += getObj(obj).price
	setLabel()

func purchase():
	var newGold = Global.getGold() + goldDiff
	if newGold < 0:
		print("Lack of Funds")
		return
	if items.is_empty():
		print("No transaction")
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
	setLabel()

func getObj(obj):
	return Global.getObj(obj.getName())
