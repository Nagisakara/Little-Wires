extends Node2D

enum plantState {POT, SAPLING, GROWN}

var leaf = preload("res://scene/leaf.tscn")

var leafs := 0
var points := {Vector2(5, 16): false, Vector2(16, 10): false}
var state := 0
var seedName : String
var numfruit := 0
var toFruit := 1

var anim : AnimatedSprite2D
var time : Timer

func _ready():
	anim = get_node("AnimatedSprite2D")
	anim.frame = plantState.POT
	time = get_node("Timer")
	time.timeout.connect(_on_timer_timeout)

func plant(newSeedName):
	if state == 0:
		anim.frame = plantState.SAPLING
		state += 1
		time.start(5)
		seedName = newSeedName
		toFruit = Global.getObj(seedName).numFruits
		return true
	else:
		return false

func _on_timer_timeout():
	match state:
		1:
			anim.frame = plantState.GROWN
			state += 1
		2:
			leafy()

func leafy():
	var key = points.find_key(false)
	var there = true
	if key != null && numfruit < toFruit:
		var newLeaf = leaf.instantiate()
		var fruit = Global.getObj(seedName).fruit
		var fruitName = fruit.name
		newLeaf.setLeaf(key, fruitName)
		newLeaf.leafed.connect(leafed)
		add_child(newLeaf)
		newLeaf.move_to_front()
		points[key] = true
		there = false
		numfruit += 1
		leafs += 1
	if there:
		time.stop()

func leafed(vec : Vector2, fruit : String):
	leafs -= 1
	points[vec] = false
	if time.is_stopped() && numfruit < Global.getObj(seedName).numFruits:
		time.start(5)
	Global.addObj(fruit)
	if numfruit == toFruit && leafs == 0:
			state = 0
			anim.frame = plantState.POT
			time.stop()
			numfruit = 0
