extends Node2D

var puzzle1Rotor = 1
var defuseCheckList = [
	"timercable1",
	"puzzle1Cable1",
	"puzzle1Cable2",
	"puzzle1Cable3",
	"puzzle1Cable4"]

func _ready() -> void:
	$CableTimer1.connect("input_event", Callable(self, "cableTimer1Cut"))
	$Puzzle1/Cable1.connect("input_event", Callable(self, "puzzle1Cable1Cut"))
	$Puzzle1/Cable2.connect("input_event", Callable(self, "puzzle1Cable2Cut"))
	$Puzzle1/Cable3.connect("input_event", Callable(self, "puzzle1Cable3Cut"))
	$Puzzle1/Cable4.connect("input_event", Callable(self, "puzzle1Cable4Cut"))
	$Puzzle1/Rotor.connect("input_event", Callable(self, "puzzle1RotorClick"))
	$BoomButton.connect("input_event", Callable(self, "boomButtonPress"))


func _process(delta: float) -> void:
	checkTime()

func boom() -> void:
	print("BOOOM")

func boomButtonPress(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if defuseCheckList.is_empty() == true:
			print("win")
		else:
			boom()

func checkTime() -> void:
	var timeLeft = int($Timer.get_time_left())
	var seconds = timeLeft % 60
	var minutes = int(timeLeft / 60)

	$SecUnits.frame = seconds % 10
	$SecTens.frame = int(seconds / 10)
	$MinUnits.frame = minutes % 10

func puzzle1RotorClick(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("Rotor")
			puzzle1Rotor=(puzzle1Rotor+1)%3
			if puzzle1Rotor==0:
				$Puzzle1/Rotor/Sprite.rotation_degrees = -48.0
			if puzzle1Rotor==1:
				$Puzzle1/Rotor/Sprite.rotation_degrees = 0.0
			if puzzle1Rotor==2:
				$Puzzle1/Rotor/Sprite.rotation_degrees = 48.0

func startTimer():
	$Timer.start(240)
	
#### Cuting cables
func changeToBroken(node: Area2D) -> void:
	node.find_child("Sprite").frame = 1;
	node.find_child("CollisionPolygon2D").disabled = true;

	
func cableTimer1Cut(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("cut cableTimer1Cut")
			changeToBroken($CableTimer1)
			if $SecUnits.frame != 2:
				boom()
			else:
				defuseCheckList.erase("timercable1")

func puzzle1Cable1Cut(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("cut puzzle1Cable1Cut")
			changeToBroken($Puzzle1/Cable1)
			if puzzle1Rotor != 0:
				boom()
			else:
				defuseCheckList.erase("puzzle1Cable1")

func puzzle1Cable2Cut(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("cut puzzle1Cable2Cut")
			changeToBroken($Puzzle1/Cable2)
			if puzzle1Rotor != 1:
				boom()
			else:
				defuseCheckList.erase("puzzle1Cable2")
				
func puzzle1Cable3Cut(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("cut puzzle1Cable3Cut")
			changeToBroken($Puzzle1/Cable3)
			if puzzle1Rotor != 2:
				boom()
			else:
				defuseCheckList.erase("puzzle1Cable3")
				
func puzzle1Cable4Cut(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("cut puzzle1Cable4Cut")
			changeToBroken($Puzzle1/Cable4)
			if puzzle1Rotor != 1:
				boom()
			else:
				defuseCheckList.erase("puzzle1Cable4")
