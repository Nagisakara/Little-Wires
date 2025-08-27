class_name Crafting extends Control

@onready var ingredients = $NinePatchRect/Ingredients
@onready var result = $NinePatchRect/Result
var ingSlots : Array
var hovered := false
var what
var button

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.sceneChanged.connect(checkClick)
	ingSlots = ingredients.get_children()

func init():
	pass

func checkClick():
	if !hovered:
		beFree()

func beFree():
	queue_free()
	button.freed()

func _on_mouse_exited():
	hovered = false

func _on_mouse_entered():
	hovered = true
