extends CanvasLayer

signal sceneChange(direction)
var coins : Label
var buttons : Array
enum button {LEFT, RIGHT}
# Called when the node enters the scene tree for the first time.
func _ready():
	var sceneLeft := get_node("Navigation/SceneLeft")
	var sceneRight := get_node("Navigation/SceneRight")
	coins = get_node("Coins")
	sceneLeft.pressed.connect(pressLeft)
	sceneRight.pressed.connect(pressRight)
	Global.goldChange.connect(setGold)
	setGold()
	buttons = [sceneLeft, sceneRight]

func pressLeft():
	sceneChange.emit(-1)
	changed()

func pressRight():
	sceneChange.emit(1)
	changed()

func setGold():
	coins.text = "Gold: " + str(Global.PlayerInventory["Gold"])

func changed():
	var current = Global.currLoaded
	match current:
		Global.scenes.PLANT:
			for i in buttons:
				i.show()
		Global.scenes.ALCHEMY:
			buttons[button.LEFT].show()
			buttons[button.RIGHT].hide()
		Global.scenes.FRONT:
			buttons[button.LEFT].hide()
			buttons[button.RIGHT].show()
