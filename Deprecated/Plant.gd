extends Node2D

enum holdState {INVENTORY, BOARD, SELLING, PURCHASING, BUY}

var area : Area2D
var soil : Area2D
var holder

var plantName : String
var state := holdState.BOARD
var follow := false
var velocity := 0.0
var pos := Vector2(0, 0)
var tempScene

func _ready():
	area = get_node("Holder/Pot")
	area.click.connect(click)
	area.unclick.connect(unclick)
	holder = get_node("Holder")
	soil = get_node("Holder/Soil")
	soil.holder = holder

func _physics_process(delta):
	if follow:
		var oldPos = self.position
		var mousePos = get_global_mouse_position() - Global.sceneCamera.position
		var newPos = (mousePos - oldPos)
		if(mousePos.distance_to(oldPos) > 10):
			velocity += .8
		else:
			velocity -= .9
		if(velocity > 15):
			velocity = 15
		elif(velocity < 0):
			velocity = 0
		self.position = oldPos + (newPos*velocity*delta)

func _input(event):
	if event.is_action_released("Click") and follow:
		var space_state = get_world_2d().direct_space_state
		var params = PhysicsPointQueryParameters2D.new() 
		params.position = get_global_mouse_position()
		params.collide_with_areas = true
		var out = space_state.intersect_point(params)
		for i in range(out.size()):
			match state:
				holdState.BOARD:
					if out[i].collider.is_in_group("Pots"):
						setPos(out[i].collider.global_position)
						state = holdState.BOARD
						out[i].collider.place(null)
						if tempScene is placeable:
							tempScene.unplace(null)
						tempScene = out[i].collider
						drop()
						return
					if out[i].collider.is_in_group("ItemButton") && holder.state == holder.plantState.POT:
						if tempScene is placeable:
							tempScene.unplace(null)
						state = holdState.INVENTORY
						drop()
						return
				holdState.INVENTORY:
					if out[i].collider.is_in_group("Pots"):
						setPos(out[i].collider.global_position)
						state = holdState.BOARD
						out[i].collider.place(null)
						if tempScene is placeable:
							tempScene.unplace(null)
						tempScene = out[i].collider
						drop()
						return
					if out[i].collider.is_in_group("Selling"):
						placeBox("Sell")
						state = holdState.SELLING
						pos = get_global_mouse_position() - Global.sceneCamera.position
						drop()
						return
				holdState.SELLING:
					if out[i].collider.is_in_group("Selling"):
						state = holdState.SELLING
						pos = get_global_mouse_position() - Global.sceneCamera.position
						drop()
						return
					if out[i].collider.is_in_group("ItemButton") && holder.state == holder.plantState.POT:
						unplaceBox("Sell")
						state = holdState.INVENTORY
						drop()
						return
				holdState.PURCHASING:
					if out[i].collider.is_in_group("Purchasing"):
						state = holdState.PURCHASING
						pos = get_global_mouse_position() - Global.sceneCamera.position
						drop()
						return
					if out[i].collider.is_in_group("SellFront"):
						unplaceBox("Buy")
						state = holdState.BUY
						drop()
						return
				holdState.BUY:
					if out[i].collider.is_in_group("Purchasing"):
						placeBox("Buy")
						state = holdState.PURCHASING
						pos = get_global_mouse_position() - Global.sceneCamera.position
						drop()
						return
		drop()

func placeBox(Which : String):
	match Which:
		"Buy":
			Global.sceneInstanced.getBuyBox().place(self)
		"Sell":
			Global.sceneInstanced.getSellBox().place(self)

func unplaceBox(Which : String):
	match Which:
		"Buy":
			Global.sceneInstanced.getBuyBox().unplace(self)
		"Sell":
			Global.sceneInstanced.getSellBox().unplace(self)

func click():
	hold()

func unclick():
	drop()

func hold():
	follow = true
	self.move_to_front()

func drop():
	follow = false
	match state:
		holdState.BOARD:
			self.position = pos
		holdState.INVENTORY:
			Global.addObj(plantName)
			queue_free()
		holdState.SELLING:
			self.position = pos
		holdState.PURCHASING:
			self.position = pos
		holdState.BUY:
			tempScene.update(plantName)
			queue_free()

func setPos(newPos : Vector2):
	pos = newPos
	pos.y -= 40

func takeOut(newName):
	plantName = newName
	state = holdState.INVENTORY
	self.position = get_global_mouse_position() - Global.sceneCamera.position
	hold()

func buyOut(sell, newName):
	plantName = newName
	tempScene = sell
	state = holdState.BUY
	self.position = get_global_mouse_position() - Global.sceneCamera.position
	hold()
