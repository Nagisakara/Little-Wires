extends Node2D

enum holdState {BOARD, INVENTORY, SELLING, PURCHASING, BUY}

var area : Area2D

var seedName : String
var state := holdState.BOARD
var follow := false
var velocity := 0.0
var pos : Vector2
var tempScene

func _ready():
	area = get_node("Area2D")
	area.click.connect(click)
	area.unclick.connect(unclick)

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
				holdState.INVENTORY:
					if out[i].collider.is_in_group("Soil"):
						if out[i].collider.plant(seedName):
							queue_free()
						else:
							state = holdState.INVENTORY
							drop()
						return
					if out[i].collider.is_in_group("SeedButton"):
						state = holdState.INVENTORY
						drop()
						return
					if out[i].collider.is_in_group("Selling"):
						placeBox("Sell")
						state = holdState.SELLING
						pos = get_global_mouse_position() - Global.sceneCamera.position
						drop()
						return
				holdState.BOARD:
					if out[i].collider.is_in_group("Soil"):
						out[i].collider.plant(seedName)
						queue_free()
						return
					if out[i].collider.is_in_group("SeedButton"):
						state = holdState.INVENTORY
						drop()
						return
				holdState.SELLING:
					if out[i].collider.is_in_group("Selling"):
						state = holdState.SELLING
						pos = get_global_mouse_position() - Global.sceneCamera.position
						drop()
						return
					if out[i].collider.is_in_group("SeedButton"):
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
	self.z_index = 1

func drop():
	follow = false
	self.z_index = 0
	match state:
		holdState.INVENTORY:
			Global.addObj(seedName)
			queue_free()
		holdState.BOARD:
			self.position = pos
		holdState.PURCHASING:
			self.position = pos
		holdState.SELLING:
			self.position = pos
		holdState.BUY:
			tempScene.update(seedName)
			queue_free()

func takeOut(newName):
	seedName = newName
	state = holdState.INVENTORY
	self.position = get_global_mouse_position() - Global.sceneCamera.position
	hold()

func buyOut(sell, newName):
	tempScene = sell
	seedName = newName
	state = holdState.BUY
	self.position = get_global_mouse_position() - Global.sceneCamera.position
	hold()