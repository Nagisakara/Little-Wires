extends Panel

var display : Sprite2D
var label : Label
var area : Area2D
var collide : CollisionShape2D
var parent
var what
var selling := true

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
	if selling:
		label.text = str(Global.ItemInventory[itemKey])
		display.visible = true
	display.texture = what.texture
	label.visible = true

func seedUpdate(seedKey : String):
	what = Global.getSeed(seedKey)
	if selling:
		label.text = str(Global.SeedInventory[seedKey])
		display.visible = true
	display.texture = what.texture
	label.visible = true

func unUpdate():
	display.visible = false
	label.visible = false
	what = null
	collide.disabled = true

func clicking():
	if what:
		var scene = what.scene.instantiate()
		Global.sceneInstanced.add_child(scene)
		Input.action_press("Click")
		scene.takeOut(what.name)
		Global.remObj(what.name)
		parent.beFree()
