class_name Clickable extends Area2D

var parent
signal click
signal unclick

func _ready():
	parent = get_parent()
	add_to_group("Click")

func assign_group(group):
	add_to_group(group)

func clicking():
	click.emit()

func unclicking():
	unclick.emit()
