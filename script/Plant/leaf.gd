class_name Leaf extends Node2D

var clipped = false
var vecy
var fruitName : String

var notif : VisibleOnScreenNotifier2D
var collide : CollisionShape2D
var area : Area2D

signal leafed()

func _ready():
	notif = get_node("VisibleOnScreenNotifier2D")
	collide = get_node("Area2D/CollisionShape2D")
	area = get_node("Area2D")
	#notif.screen_exited.connect(exited)
	area.click.connect(click)
	area.unclick.connect(unclick)

func setLeaf(vec : Vector2, newName : String):
	self.position.y = self.position.y - 32 - vec.y
	self.position.x = self.position.x + vec.x
	self.scale = Vector2(.5, .5)
	fruitName = newName
	vecy = vec
	randAngle()

func randAngle():
	var rng = RandomNumberGenerator.new()
	var angle = rng.randf_range(75, 192)
	self.rotation = deg_to_rad(angle)

func click():
	clipped = true
	self.z_index = 1
	self.reparent(Global.sceneInstanced)
	collide.disabled = true
	
func unclick():
	pass

func _physics_process(delta):
	if clipped:
		self.position.y += 3 * 60 * delta
		self.rotation += deg_to_rad(5 * 60) * delta
		if position.y > get_viewport_rect().size.y:
			exited()

func exited():
	if clipped:
		leafed.emit(vecy, fruitName)
		Global.purchase.emit()
		self.queue_free()
