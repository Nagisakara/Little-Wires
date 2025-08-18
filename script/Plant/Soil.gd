extends Area2D

signal planted(something)

func plant(seedName):
	planted.emit(seedName)