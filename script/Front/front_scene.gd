extends Node2D

func getScene():
	return Global.scenes.FRONT

func getBuyBox():
	return $StoreFront/BuyBox

func getSellBox():
	return $StoreFront/SellBox