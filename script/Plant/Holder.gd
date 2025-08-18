extends Node2D

enum plantState {POT, SAPLING, GROWN}

var leaf = preload("res://scene/leaf.tscn")

var leafs := 0
var points := {Vector2(5, 16): false, Vector2(16, 10): false}
var state := 0

var anim : AnimatedSprite2D
var time : Timer

func _ready():
	anim = get_node("AnimatedSprite2D")
	anim.frame = plantState.POT
	time = get_node("Timer")
	time.timeout.connect(_on_timer_timeout)

func plant(seedName):
	anim.frame = plantState.SAPLING
	state += 1
	time.start(5)
	get_parent().seedName = seedName

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
	if key != null:
		var newLeaf = leaf.instantiate()
		newLeaf.setPos(key)
		newLeaf.leafed.connect(leafed)
		add_child(newLeaf)
		newLeaf.move_to_front()
		points[key] = true
		there = false
	if there:
		time.stop()

func leafed(vec : Vector2):
	points[vec] = false
	if time.is_stopped():
		time.start(5)
	get_parent().plucked.emit()
