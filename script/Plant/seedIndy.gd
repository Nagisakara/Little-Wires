extends Node2D

var drag
enum holdState {BOARD, INVENTORY, SELLING, PURCHASING, BUY}
var state
var seedName : String
var tempScene

func setUp(newDrag):
	drag = newDrag
	state = holdState.BOARD
	drag.area = drag.get_node("Area2D")
	drag.area.click.connect(drag.click)
	drag.area.unclick.connect(drag.unclick)

func setName(newName):
	seedName = newName

func getName():
	return seedName

func checkCollide(collider):
	match state:
		holdState.INVENTORY:
			if collider.is_in_group("Soil"):
				if collider.plant(seedName):
					drag.queue_free()
				else:
					state = holdState.INVENTORY
					drop()
				return true
			if collider.is_in_group("SeedButton"):
				state = holdState.INVENTORY
				drop()
				return true
			if collider.is_in_group("Selling"):
				placeBox("Sell")
				state = holdState.SELLING
				drag.pos = get_global_mouse_position() - Global.sceneCamera.position
				drop()
				return true
		holdState.BOARD:
			if collider.is_in_group("Soil"):
				collider.plant(seedName)
				drag.queue_free()
				return true
			if collider.is_in_group("SeedButton"):
				state = holdState.INVENTORY
				drop()
				return true
		holdState.SELLING:
			if collider.is_in_group("Selling"):
				state = holdState.SELLING
				drag.pos = get_global_mouse_position() - Global.sceneCamera.position
				drop()
				return true
			if collider.is_in_group("SeedButton"):
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
		holdState.INVENTORY:
			Global.addObj(seedName)
			drag.queue_free()
		holdState.BOARD:
			drag.position = drag.pos 
		holdState.PURCHASING:
			drag.position = drag.pos
		holdState.SELLING:
			drag.position = drag.pos 
		holdState.BUY:
			tempScene.update(seedName)
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
