extends Camera2D

var targetPos := position
const moveBy := 5
var mov := false

func setPos(target):
	targetPos = target
	mov = true

func _physics_process(delta):
	if mov:
		if position.distance_to(targetPos) > moveBy:
			position += (targetPos - position) * (moveBy * delta)
		else:
			position = targetPos
	