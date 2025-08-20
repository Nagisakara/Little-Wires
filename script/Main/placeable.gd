class_name placeable extends Area2D

signal placed
signal unplaced

# Called when the node enters the scene tree for the first time.
func setGroup(group : String):
	add_to_group(group)

func remGroup(group : String):
	remove_from_group(group)

func setPos(vec : Vector2):
	self.position = vec

func place(obj):
	if obj:
		placed.emit(self, obj)
	else:
		placed.emit(self)

func unplace(obj):
	if obj:
		unplaced.emit(self, obj)
	else:
		unplaced.emit(self)
