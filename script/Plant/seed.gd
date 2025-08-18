extends Node2D

enum holdState {BOARD, INVENTORY}

var area : Area2D

var seedName : String
var state := holdState.BOARD
var follow := false
var velocity := 0.0
var pos : Vector2

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

func _unhandled_input(event):
	if event.is_action_released("Click") and follow:
		var space_state = get_world_2d().direct_space_state
		var params = PhysicsPointQueryParameters2D.new() 
		params.position = get_global_mouse_position()
		params.collide_with_areas = true
		var out = space_state.intersect_point(params)
		for i in range(out.size()):
			if out[i].collider.is_in_group("Soil") and Global.currLoaded == Global.scenes.PLANT:
				out[i].collider.plant(seedName)
				queue_free()
				return
			if out[i].collider.is_in_group("Shop"):
				state = holdState.BOARD
				pos = get_global_mouse_position() - Global.sceneCamera.position
				drop()
				return
			if out[i].collider.is_in_group("SeedButton"):
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
	self.z_index = 1

func drop():
	follow = false
	match state:
		holdState.INVENTORY:
			self.z_index = 0
			Global.addSeed(seedName)
			queue_free()
		holdState.BOARD:
			self.position = pos

func takeOut(newName):
	seedName = newName
	state = holdState.INVENTORY
	self.position = get_global_mouse_position() - Global.sceneCamera.position
	hold()
