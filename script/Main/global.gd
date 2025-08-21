extends Node

signal purchase(item)
signal goldChange
signal sceneChanged
signal click

enum scenes {FRONT, PLANT, ALCHEMY}

var sceneInstances #List of all major scenes - as in enum
var sceneInstanced #Currently centered scene
var sceneUI 
var sceneCamera

var currLoaded := scenes.PLANT
var ShopLoaded : ShopData

#Databases - Name : Data
var ItemDatabase : Dictionary = {}
var SeedDatabase : Dictionary = {}
var Shops : Dictionary = {}
#Inventories - Name : # of Name
var ItemInventory : Dictionary = {}
var SeedInventory : Dictionary = {}

var PlayerInventory = {
	"Gold" : 8
}

func _ready():
	var itemPath = "res://resource/Items"
	var seedPath = "res://resource/Seeds"
	var shopPath = "res://resource/Shops"
	for file in DirAccess.get_files_at(itemPath):
		var res_file = itemPath + "/" + file
		var item : ItemData = load(res_file) as ItemData
		ItemDatabase[item.name] = item
	for file in DirAccess.get_files_at(seedPath):
		var res_file = seedPath + "/" + file
		var seeds : SeedData = load(res_file) as SeedData
		SeedDatabase[seeds.name] = seeds
	for file in DirAccess.get_files_at(shopPath):
		var res_file = shopPath + "/" + file
		var shop : ShopData = load(res_file) as ShopData
		Shops[shop.name] = shop
	ShopLoaded = Shops["Starter"]

func getItem(itemName : String):
	if ItemDatabase.has(itemName):
		return ItemDatabase[itemName]
	else:
		return null

func getSeed(seedName : String):
	if SeedDatabase.has(seedName):
		return SeedDatabase[seedName]
	else:
		return null

func getObj(objName : String):
	if getItem(objName):
		return getItem(objName)
	elif getSeed(objName):
		return getSeed(objName)
	else:
		return null

func addObj(objName : String):
	if getSeed(objName):
		if SeedInventory.has(objName):
			SeedInventory[objName] += 1
		else:
			SeedInventory[objName] = 1
	elif getItem(objName):
		if ItemInventory.has(objName):
			ItemInventory[objName] += 1
		else:
			ItemInventory[objName] = 1

func remObj(objName : String):
	if SeedInventory.has(objName):
		if SeedInventory[objName] > 1:
			SeedInventory[objName] -= 1
		else:
			SeedInventory.erase(objName)
	elif ItemInventory.has(objName):
		if ItemInventory[objName] > 1:
			ItemInventory[objName] -= 1
		else:
			ItemInventory.erase(objName)

func changeGold(newGold):
	PlayerInventory["Gold"] += newGold
	goldChange.emit()

func getGold():
	return PlayerInventory["Gold"]

func instanced():
	sceneInstanced = sceneInstances[currLoaded]

func cameraReady():
	return abs(sceneCamera.get_target_position().x - sceneCamera.get_screen_center_position().x) < 15
