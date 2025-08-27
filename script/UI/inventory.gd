extends Control

@onready var grid = $NinePatchRect/GridContainer
var slots : Array
var hovered := false
var what
var button

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.click.connect(checkClick)
	Global.sceneChanged.connect(checkClick)
	Global.purchase.connect(invChanged)
	slots = grid.get_children()

func init(which : String):
	what = which
	for i in range(9):
			match what:
				"Seed":
					if(i < Global.SeedInventory.size()):
						var key = Global.SeedInventory.keys()[i]
						slots[i].seedUpdate(key)
						slots[i].parent = self
					else:
						slots[i].unUpdate()
						slots[i].parent = self
				"Item":
					if(i < Global.ItemInventory.size()):
						var key = Global.ItemInventory.keys()[i]
						slots[i].itemUpdate(key)
						slots[i].parent = self
					else:
						slots[i].unUpdate()
						slots[i].parent = self

func checkClick():
	if !hovered:
		beFree()

func invChanged():
	init(what)

func beFree():
	queue_free()
	button.freed()

func _on_mouse_exited():
	hovered = false

func _on_mouse_entered():
	hovered = true
