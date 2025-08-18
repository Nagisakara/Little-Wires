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

#Databases - Name : Data
var ItemDatabase : Dictionary = {}
var SeedDatabase : Dictionary = {}

#Inventories - Name : # of Name
var ItemInventory : Dictionary = {}
var SeedInventory : Dictionary = {}
var ShopSelling : Dictionary = {}	#Shop -> Player
var ShopBuying : Dictionary = {}	#Player -> Shop

var PlayerInventory = {
	"Gold" : 0
}

func _ready():
	var itemPath = "res://resource/Items"
	var seedPath = "res://resource/Seeds"
	for file in DirAccess.get_files_at(itemPath):
		var res_file = itemPath + "/" + file
		var item : ItemData = load(res_file) as ItemData
		ItemDatabase[item.name] = item
	for file in DirAccess.get_files_at(seedPath):
		var res_file = seedPath + "/" + file
		var seeds : SeedData = load(res_file) as SeedData
		SeedDatabase[seeds.name] = seeds

func addItem(itemName : String):
	if ItemInventory.has(itemName):
		ItemInventory[itemName] += 1
	else:
		ItemInventory[itemName] = 1

func getItem(itemName : String):
	if ItemDatabase.has(itemName):
		return ItemDatabase[itemName]
	else:
		return null

func remItem(itemName : String):
	if ItemInventory.has(itemName):
		if ItemInventory[itemName] > 1:
			ItemInventory[itemName] -= 1
		else:
			ItemInventory.erase(itemName)

func addSeed(seedName : String):
	if SeedInventory.has(seedName):
		SeedInventory[seedName] += 1
	else:
		SeedInventory[seedName] = 1

func getSeed(seedName : String):
	if SeedDatabase.has(seedName):
		return SeedDatabase[seedName]
	else:
		return null

func remSeed(seedName : String):
	if SeedInventory.has(seedName):
		if SeedInventory[seedName] > 1:
			SeedInventory[seedName] -= 1
		else:
			SeedInventory.erase(seedName)

func changeGold(newGold):
	PlayerInventory["Gold"] += newGold
	goldChange.emit()

func instanced():
	sceneInstanced = sceneInstances[currLoaded]

func cameraReady():
	return abs(sceneCamera.get_target_position().x - sceneCamera.get_screen_center_position().x) < 15