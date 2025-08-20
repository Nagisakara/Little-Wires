class_name sellSlot extends Panel

var display : Sprite2D
var label : Label
var area : Area2D
var collide : CollisionShape2D
var parent
var what

func _ready():
	display = get_node("Display")
	label = get_node("Label")
	area = get_node("Area2D")
	collide = get_node("Area2D/CollisionShape2D")
	display.visible = false
	label.visible = false
	area.click.connect(clicking)

func itemUpdate(itemKey : String):
	what = Global.getItem(itemKey)
	label.text = str(what.price)
	display.texture = what.texture
	display.visible = true
	label.visible = true
	collide.disabled = false

func seedUpdate(seedKey : String):
	what = Global.getSeed(seedKey)
	label.text = str(what.price)
	display.texture = what.texture
	display.visible = true
	label.visible = true
	collide.disabled = false

func unUpdate():
	display.visible = false
	label.visible = false
	what = null
	collide.disabled = true

func clicking():
	if what:
		var scene = what.scene.instantiate()
		Global.sceneInstanced.add_child(scene)
		scene.buyOut(self, what.name)
		Input.action_press("Click")
		unUpdate()
