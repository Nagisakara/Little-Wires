extends Node2D

enum holdState {INVENTORY, BOARD, SHOP, SELL}

var area : Area2D
var soil : Area2D
var holder

var plantName : String
var seedName : String
var state := holdState.BOARD
var follow := false
var velocity := 0.0
var potPos := Vector2(0, 0)
var pot

signal plucked

func _ready():
	area = get_node("Holder/Pot")
	area.click.connect(click)
	area.unclick.connect(unclick)
	holder = get_node("Holder")
	soil = get_node("Holder/Soil")
	soil.planted.connect(holder.plant)

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

func _unhandled_input(event):
	if event.is_action_released("Click") and follow:
		var space_state = get_world_2d().direct_space_state
		var params = PhysicsPointQueryParameters2D.new() 
		params.position = get_global_mouse_position()
		params.collide_with_areas = true
		var out = space_state.intersect_point(params)
		for i in range(out.size()):
			if out[i].collider.is_in_group("Pots"):
				setPot(out[i].collider.global_position)
				state = holdState.BOARD
				out[i].collider.place()
				if pot:
					pot.unplace()
				pot = out[i].collider
				drop()
				return
			if out[i].collider.is_in_group("Shop"):
				state = holdState.SHOP
				if pot:
					pot.unplace()
				potPos = get_global_mouse_position() - Global.sceneCamera.position
				drop()
				return
			if out[i].collider.is_in_group("ItemButton") && holder.state == holder.plantState.POT:
				if pot:
					pot.unplace()
				state = holdState.INVENTORY
				drop()
				return
		drop()

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
			self.position = potPos
		holdState.INVENTORY:
			Global.addItem(plantName)
			queue_free()
		holdState.SHOP:
			self.position = potPos

func setPot(pos : Vector2):
	potPos = pos
	potPos.y -= 40

func takeOut(newName):
	plantName = newName
	state = holdState.INVENTORY
	self.position = get_global_mouse_position() - Global.sceneCamera.position
	if Global.currLoaded == Global.scenes.PLANT:
		self.plucked.connect(Global.sceneInstanced.harvest)
	hold()

func buyOut():
	state = holdState.SELL
	self.position = get_global_mouse_position() - Global.sceneCamera.position
	hold()