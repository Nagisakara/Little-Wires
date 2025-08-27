extends Node2D

var drag
enum holdState {BOARD, INVENTORY, SELLING, PURCHASING, BUY}
var state
var plantName : String
var tempScene

var holder

func setUp(newDrag):
	drag = newDrag
	state = holdState.BOARD
	holder = drag.get_node("Holder")
	var soil = holder.get_node("Soil")
	soil.holder = holder
	drag.area = holder.get_node("Pot")
	drag.area.click.connect(drag.click)
	drag.area.unclick.connect(drag.unclick)

func setName(newName):
	plantName = newName

func getName():
	return plantName

func checkCollide(collider):
	match state:
		holdState.BOARD:
			if collider.is_in_group("Pots"):
				setPos(collider.global_position)
				state = holdState.BOARD
				collider.place(null)
				if tempScene is placeable:
					tempScene.unplace(null)
				tempScene = collider
				drop()
				return true
			if collider.is_in_group("ItemButton") && holder.state == holder.plantState.POT:
				if tempScene is placeable:
					tempScene.unplace(null)
				state = holdState.INVENTORY
				drop()
				return true
		holdState.INVENTORY:
			if collider.is_in_group("Pots"):
				setPos(collider.global_position)
				state = holdState.BOARD
				collider.place(null)
				if tempScene is placeable:
					tempScene.unplace(null)
				tempScene = collider
				drop()
				return true
			if collider.is_in_group("Selling"):
				placeBox("Sell")
				state = holdState.SELLING
				drag.pos = get_global_mouse_position() - Global.sceneCamera.position
				drop()
				return true
		holdState.SELLING:
			if collider.is_in_group("Selling"):
				state = holdState.SELLING
				drag.pos = get_global_mouse_position() - Global.sceneCamera.position
				drop()
				return true
			if collider.is_in_group("ItemButton") && holder.state == holder.plantState.POT:
				unplaceBox("Sell")
				state = holdState.INVENTORY
				drop()
				return true
		holdState.PURCHASING:
			if collider.is_in_group("Purchasing"):
				state = holdState.PURCHASING
				drag.pos = get_global_mouse_position() - Global.sceneCamera.position
				drop()
				return true
			if collider.is_in_group("SellFront"):
				unplaceBox("Buy")
				state = holdState.BUY
				drop()
				return true
		holdState.BUY:
			if collider.is_in_group("Purchasing"):
				placeBox("Buy")
				state = holdState.PURCHASING
				drag.pos = get_global_mouse_position() - Global.sceneCamera.position
				drop()
				return true
	return false

func hold():
	drag.follow = true
	drag.move_to_front()   
	drag.z_index = 1

func drop():
	drag.follow = false
	drag.z_index = 0
	match state:
		holdState.BOARD:
			drag.position = drag.pos 
		holdState.INVENTORY:
			Global.addObj(plantName)
			drag.queue_free()
		holdState.SELLING:
			drag.position = drag.pos 
		holdState.PURCHASING:
			drag.position = drag.pos 
		holdState.BUY:
			tempScene.update(plantName)
			drag.queue_free()

func placeBox(Which : String):
	match Which:
		"Buy":
			Global.sceneInstanced.getBuyBox().place(drag)
		"Sell":
			Global.sceneInstanced.getSellBox().place(drag)

func unplaceBox(Which : String):
	match Which:
		"Buy":
			Global.sceneInstanced.getBuyBox().unplace(drag)
		"Sell":
			Global.sceneInstanced.getSellBox().unplace(drag)

func setPos(newPos : Vector2):
	drag.pos = newPos
	drag.pos.y -= 40
