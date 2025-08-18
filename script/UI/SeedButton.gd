extends Node2D

var inventory = preload("res://scene/inventory.tscn")

var open := false
var area : Area2D
var inv

func freed():
	open = false

func _ready():
	area = get_node("Area2D")
	area.assign_group("SeedButton")
	area.click.connect(clicking)

func clicking():
	if !Global.cameraReady():
		return
	if !open:
		Global.click.emit()
		inv = inventory.instantiate()
		inv.position = Vector2(200, -300)
		inv.button = self
		Global.sceneInstanced.add_child(inv)
		inv.init("Seed")
		open = true
	else:
		open = false
		inv.queue_free()