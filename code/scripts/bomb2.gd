extends Node2D

@export var bombDefuseTime = 240

var timerSecUnitsEnable = true
var timerSecTensEnable = true
var timerMinUnitsEnable = true

var defuseCheckList = []
var srobaActiveList = [1,2,3,4]


func _ready() -> void:
	$Timer.start(bombDefuseTime)
	$Dots.play()
	#$"Red-LED/LedOn".play()
	#$"Red-LED/LedGlow".play()
	
	####Greek####
	$"Zagadka-Grecka/Outer/Omega".connect("input_event", Callable(self, "greekPuzzleOmega"))
	$"Zagadka-Grecka/Outer/Teta".connect("input_event", Callable(self, "greekPuzzleTeta"))
	$"Zagadka-Grecka/Outer/Fi".connect("input_event", Callable(self, "greekPuzzleFi"))
	$"Zagadka-Grecka/Outer/Delta".connect("input_event", Callable(self, "greekPuzzleDelta"))
	$"Zagadka-Grecka/Outer/Sroba1".connect("input_event", func(viewport, event, shape_idx): 
									srobaClick(1, viewport, event, shape_idx))
	$"Zagadka-Grecka/Outer/Sroba2".connect("input_event", func(viewport, event, shape_idx): 
									srobaClick(2, viewport, event, shape_idx))
	$"Zagadka-Grecka/Outer/Sroba3".connect("input_event", func(viewport, event, shape_idx): 
									srobaClick(3, viewport, event, shape_idx))
	$"Zagadka-Grecka/Outer/Sroba4".connect("input_event", func(viewport, event, shape_idx): 
									srobaClick(4, viewport, event, shape_idx))
									
	####Rotor####
	$"Zagadka-Tarcza".connect("input_event", Callable(self, "OuterRotor"))

	####Letter####
	$"Zagadka-Litery/1/Up".connect("input_event", func(viewport, event, shape_idx): 
							letterOrientationButtonPress(1, "Up", viewport, event, shape_idx))
	$"Zagadka-Litery/1/Down".connect("input_event", func(viewport, event, shape_idx): 
							letterOrientationButtonPress(1, "Down", viewport, event, shape_idx))
	$"Zagadka-Litery/2/Up".connect("input_event", func(viewport, event, shape_idx): 
							letterOrientationButtonPress(2, "Up", viewport, event, shape_idx))
	$"Zagadka-Litery/2/Down".connect("input_event", func(viewport, event, shape_idx): 
							letterOrientationButtonPress(2, "Down", viewport, event, shape_idx))
	$"Zagadka-Litery/3/Up".connect("input_event", func(viewport, event, shape_idx): 
							letterOrientationButtonPress(3, "Up", viewport, event, shape_idx))
	$"Zagadka-Litery/3/Down".connect("input_event", func(viewport, event, shape_idx): 
							letterOrientationButtonPress(3, "Down", viewport, event, shape_idx))
	$"Zagadka-Litery/4/Up".connect("input_event", func(viewport, event, shape_idx): 
							letterOrientationButtonPress(4, "Up", viewport, event, shape_idx))
	$"Zagadka-Litery/4/Down".connect("input_event", func(viewport, event, shape_idx): 
							letterOrientationButtonPress(4, "Down", viewport, event, shape_idx))

func _process(delta: float) -> void:
	checkTime()
	RotorDragRotation()
	



func boom() -> void:
	print("BOOOM")
	get_tree().reload_current_scene()

func win() -> void:
	var timeLeft = int($Timer.get_time_left())
	var seconds = timeLeft % 60
	var minutes = int(timeLeft / 60)
	$Timer.stop()
	$Dots.stop()
	
	for i in range(3):
		timerSecUnitsEnable=false
		timerSecTensEnable=false
		timerMinUnitsEnable=false
		$SecUnits.frame = 12
		$SecTens.frame = 12
		$MinUnits.frame = 12
		$MinTens.frame = 12
		$Dots.frame = 0
		await get_tree().create_timer(1.0).timeout
		$SecUnits.frame = seconds % 10
		$SecTens.frame = int(seconds / 10)
		$MinUnits.frame = minutes % 10
		$MinTens.frame = 0
		$Dots.frame = 1
		await get_tree().create_timer(1.0).timeout
	print("WIN")


func boomButtonPress(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if defuseCheckList.is_empty() == true:
			win()
		else:
			boom()

func checkTime() -> void:
	var timeLeft = int($Timer.get_time_left())
	var seconds = timeLeft % 60
	var minutes = int(timeLeft / 60)
	
	if timerSecUnitsEnable:
		$SecUnits.frame = seconds % 10
	if timerSecTensEnable:
		$SecTens.frame = int(seconds / 10)
	if timerMinUnitsEnable:
		$MinUnits.frame = minutes % 10

#####Greek puzzle#####
func greekPuzzleOmega(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			$"Zagadka-Grecka/Outer/Omega/Sprite".frame = 2
		else:
			$"Zagadka-Grecka/Outer/Omega/Sprite".frame = 1

func greekPuzzleTeta(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			$"Zagadka-Grecka/Outer/Teta/Sprite".frame = 2
		else:
			$"Zagadka-Grecka/Outer/Teta/Sprite".frame = 1

func greekPuzzleFi(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			$"Zagadka-Grecka/Outer/Fi/Sprite".frame = 2
		else:
			$"Zagadka-Grecka/Outer/Fi/Sprite".frame = 1

func greekPuzzleDelta(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			$"Zagadka-Grecka/Outer/Delta/Sprite".frame = 2
		else:
			$"Zagadka-Grecka/Outer/Delta/Sprite".frame = 1

func srobaClick(number, viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var srobaHandler = $"Zagadka-Grecka/Outer".find_child("Sroba"+str(number))
		srobaHandler.find_child("Sprite").visible = false
		srobaHandler.find_child("CollisionShape2D").disabled = true
		srobaActiveList.erase(number)
		if srobaActiveList.is_empty():
			takeLidOff()

func takeLidOff():
	$"Zagadka-Grecka/Outer".visible = false
	$"Zagadka-Grecka/Baza".frame = 0

func buttonHighLight(name: String):
	var nodeSpriteHandler = $"Zagadka-Grecka".find_child(name).find_child("Sprite")
	if nodeSpriteHandler.frame != 2:
		nodeSpriteHandler.frame = 1
	
func buttonDeHighLight(name: String):
	$"Zagadka-Grecka".find_child(name).find_child("Sprite").frame = 0

#####Telephone rotor puzzle#####
var isDragging = false
var startRotation = 0.0
var maxRotation = deg_to_rad(342)
var lastMouseAngle = 0.0

func OuterRotor(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			isDragging = true
			startRotation = $"Zagadka-Tarcza/Sprite".rotation
			lastMouseAngle = getGlobalMouseAngle()
		else:
			stopDrag()

func getGlobalMouseAngle():
	var mousePos = get_global_mouse_position()
	var rotorCenter = $"Zagadka-Tarcza/Sprite".global_position
	var dir = mousePos - rotorCenter
	return dir.angle()

func RotorDragRotation():
	var rotor = $"Zagadka-Tarcza/Sprite"
	var delta = get_process_delta_time()
	var currentRotation = rotor.rotation

	if isDragging:
		var currentAngle = getGlobalMouseAngle()
		var deltaAngle = wrapf(currentAngle - lastMouseAngle, -PI, PI)
		lastMouseAngle = currentAngle

		var targetRotation = clamp(currentRotation + deltaAngle, 0, maxRotation)

		var maxSpeed = deg_to_rad(180)
		var maxStep = maxSpeed * delta

		var diff = clamp(targetRotation - currentRotation, -maxStep, maxStep)
		rotor.rotation = currentRotation + diff
	else:
		var returnSpeed = deg_to_rad(90)
		var maxReturnStep = returnSpeed * delta

		if currentRotation <= 0:
			rotor.rotation = 0
		else:
			var newRotation = currentRotation - maxReturnStep
			if newRotation < 0:
				newRotation = 0
			rotor.rotation = newRotation

func stopDrag():
	if isDragging == true:
		var rotationAngle = rad_to_deg($"Zagadka-Tarcza/Sprite".rotation)
		print(ceil((rotationAngle-105.0)/25))
	isDragging = false

func rotorHighLight():
	$"Zagadka-Tarcza/Sprite".frame = 1

func rotorDeHighLight():
	$"Zagadka-Tarcza/Sprite".frame = 0
	stopDrag()


####Letter puzzle####
func letterOrientationButtonPress(number: int, orientation: String, viewport, event, shape_idx):
	pass

func letterOrientationButtonHighlight(number: int, orientation: String):
	$"Zagadka-Litery".find_child(str(number)).find_child(orientation).find_child("Sprite").frame = 1

func letterOrientationButtonDeHighlight(number: int, orientation: String):
	$"Zagadka-Litery".find_child(str(number)).find_child(orientation).find_child("Sprite").frame = 0
