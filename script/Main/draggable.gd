class_name Drag extends Node2D

var area : Area2D
@onready var indy : Node2D = $Indy

var thisName : String
var follow := false
var velocity := 0.0
var pos := Vector2(0, 0)

func _ready():
	indy.setUp(self)

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
			if indy.checkCollide(out[i].collider):
				return
		unclick()

func click():
	indy.hold()

func unclick():
	indy.drop()

func takeOut(newName):
	indy.setName(newName)
	indy.state = indy.holdState.INVENTORY
	self.position = get_global_mouse_position() - Global.sceneCamera.position
	indy.hold()

func buyOut(sell, newName):
	indy.tempScene = sell
	indy.setName(newName)
	indy.state = indy.holdState.BUY
	self.position = get_global_mouse_position() - Global.sceneCamera.position
	indy.hold()

func getName():
	return indy.getName()
