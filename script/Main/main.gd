extends Node2D

var scenes : Array
var camera : Camera2D

func _ready():
	var plant = get_node("PlantScene")
	var alchemy = get_node("AlchemyScene")
	var front = get_node("FrontScene")
	var UI = get_node("UI")
	camera = get_node("Camera2D")
	UI.sceneChange.connect(changeScene)
	scenes = [front, plant, alchemy]
	Global.sceneUI = UI
	Global.sceneInstances = scenes
	Global.sceneCamera = camera
	Global.instanced()

func changeScene(direction):
	if (Global.currLoaded + direction >= 0) && (Global.currLoaded + direction < scenes.size()):
		Global.currLoaded = Global.currLoaded + direction
		camera.setPos(scenes[Global.currLoaded].position)
		Global.sceneChanged.emit()
		Global.instanced()

func _input(event):
	if event.is_action_pressed("Click") && Global.cameraReady():
		var space_state = get_world_2d().direct_space_state
		var params = PhysicsPointQueryParameters2D.new() 
		params.position = get_global_mouse_position()
		params.collide_with_areas = true
		var out = space_state.intersect_point(params)
		for i in range(out.size()):
			if out[i].collider.is_in_group("Click"):
				out[i].collider.clicking()
				return
		Global.click.emit()
