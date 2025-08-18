extends Node2D

var rng = RandomNumberGenerator.new()
var clipped = false
var vecy
var notif : VisibleOnScreenNotifier2D
var collide : CollisionShape2D
var root
var area : Area2D
signal leafed(which)

func _ready():
	notif = get_node("VisibleOnScreenNotifier2D")
	collide = get_node("Area2D/CollisionShape2D")
	area = get_node("Area2D")
	#notif.screen_exited.connect(exited)
	root = get_tree().root
	area.click.connect(click)
	area.unclick.connect(unclick)

func setPos(vec : Vector2):
	self.position.y = self.position.y - 32 - vec.y
	self.position.x = self.position.x + vec.x
	self.scale = Vector2(.5, .5)
	vecy = vec
	randAngle()

func randAngle():
	var angle = rng.randf_range(75, 192)
	self.rotation = deg_to_rad(angle)

func click():
	clipped = true
	self.z_index = 1
	self.reparent(root.get_node("Main/PlantScene"))
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
		leafed.emit(vecy)
		self.queue_free()
