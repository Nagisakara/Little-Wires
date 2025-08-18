extends Node2D

var inventory = preload("res://scene/inventory.tscn")

var open := false
var inv
var area : Area2D

func freed():
	open = false

func _ready():
	area = get_node("Area2D")
	area.assign_group("ItemButton")
	area.click.connect(clicking)

func clicking():
	if !Global.cameraReady():
		return
	if !open:
		Global.click.emit()
		inv = inventory.instantiate()
		inv.position = Vector2(200, 50)
		inv.button = self
		Global.sceneInstanced.add_child(inv)
		inv.init("Item")
		open = true
	else:
		open = false
		inv.queue_free()