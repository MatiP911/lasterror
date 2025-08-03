extends Node2D

@export var bombDefuseTime = 240

@export var disturberTimers = ['nothing', 20, 50, 90, 140]

signal explosion

var clockEnabled = true


var ledCheckList = ["Greek", "Letter", "Switch", "Phone"]
var srobaActiveList = [1,2,3,4]
var cableCheckList = ["White", "Purple", "Pink", "Yellow"]

func _ready() -> void:
	$Timer.start(bombDefuseTime)
	$Dots.play()
	
	$"BoomButton".connect("input_event", Callable(self, "boomButtonClick"))
	
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
	$"Zagadka-Grecka/Drawer/ScrewDriver".connect("input_event", Callable(self, "screwdriverClick"))

	for i in range(1,5):
		$"Zagadka-Grecka".find_child("Disturbe"+str(i)).start(disturberTimers[i]-1)
		
	####Rotor####
	$"Zagadka-Tarcza".connect("input_event", Callable(self, "OuterRotor"))
	$"Zagadka-Tarcza/Clear".connect("input_event", Callable(self, "clearButtonClick"))

	####Letter####
	turnDownLetters(false)
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

	####Switch####
	$"Zagadka-Switch/Switches/Switch1".connect("input_event", func(viewport, event, shape_idx): 
							switchClick(1, viewport, event, shape_idx))
	$"Zagadka-Switch/Switches/Switch2".connect("input_event", func(viewport, event, shape_idx): 
							switchClick(2, viewport, event, shape_idx))
	$"Zagadka-Switch/Switches/Switch3".connect("input_event", func(viewport, event, shape_idx): 
							switchClick(3, viewport, event, shape_idx))
	$"Zagadka-Switch/Switches/Switch4".connect("input_event", func(viewport, event, shape_idx): 
							switchClick(4, viewport, event, shape_idx))
	$"Zagadka-Switch/Switches/Switch5".connect("input_event", func(viewport, event, shape_idx): 
							switchClick(5, viewport, event, shape_idx))
	$"Zagadka-Switch/Base/Outer".connect("input_event", Callable(self, "OuterRotorClick"))
	$"Zagadka-Switch/Base/Inner".connect("input_event", Callable(self, "InnerRotorClick"))
	
	$"Zagadka-Switch/Base".visible = false
	
	####Timer cables####
	$"TimerCables/Pink".connect("input_event", func(viewport, event, shape_idx): 
							cableCut("Pink", viewport, event, shape_idx))
	$"TimerCables/Yellow".connect("input_event", func(viewport, event, shape_idx): 
							cableCut("Yellow", viewport, event, shape_idx))
	$"TimerCables/White".connect("input_event", func(viewport, event, shape_idx): 
							cableCut("White", viewport, event, shape_idx))
	$"TimerCables/Purple".connect("input_event", func(viewport, event, shape_idx): 
							cableCut("Purple", viewport, event, shape_idx))

func _process(delta: float) -> void:
	checkTime()
	RotorDragRotation()

func boomButtonClick(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		$"BoomButton/BoomButtonClick".play()
		if not ledCheckList.is_empty():
			boom()
			return
		win()

func boom() -> void:
	emit_signal("explosion")

func win() -> void:
	var timeLeft = int($Timer.get_time_left())
	var seconds = timeLeft % 60
	var minutes = int(timeLeft / 60)
	$Timer.stop()
	$Dots.stop()
	
	for i in range(3):
		clockEnabled = false
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

func checkTime() -> void:
	var timeLeft = int($Timer.get_time_left())
	var seconds = timeLeft % 60
	var minutes = int(timeLeft / 60)
	
	if clockEnabled:
		$SecUnits.frame = seconds % 10
		$SecTens.frame = int(seconds / 10)
		$MinUnits.frame = minutes % 10

func mainTimerTimeOut():
	clockEnabled = false
	for i in range(0,3):
		$"MinTens".frame = 13
		$"MinUnits".frame = 14
		$"SecTens".frame = 15
		$"SecUnits".frame = 16
		await get_tree().create_timer(0.5).timeout
		$"MinTens".frame = 12
		$"MinUnits".frame = 12
		$"SecTens".frame = 12
		$"SecUnits".frame = 12
		await get_tree().create_timer(0.5).timeout
	boom()


func ledCheckListChecker():
	if ledCheckList.rfind("Greek") == -1:
		$"LEDs/LEDOn".play()
		$"LEDs/White".visible = true
	if ledCheckList.rfind("Letter") == -1:
		$"LEDs/LEDOn".play()
		$"LEDs/Pink".visible = true
	if ledCheckList.rfind("Switch") == -1:
		$"LEDs/LEDOn".play()
		$"LEDs/Purple".visible = true
	if ledCheckList.rfind("Phone") == -1:
		$"LEDs/LEDOn".play()
		$"LEDs/Orange".visible = true

#####Greek puzzle#####
var numbersToGreek = [5, 3, 7, 2]
var greekCombo = [3,3,1,2,0,0,3,2]
var currentCombo = []
func greekPuzzleOmega(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			$"Zagadka-Grecka/Outer/Omega/Sprite".frame = 2
			checkDisturbe(1)
			currentCombo.append(1)
			checkGreekCombo()
		else:
			$"Zagadka-Grecka/Outer/Omega/Sprite".frame = 1

func greekPuzzleTeta(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			$"Zagadka-Grecka/Outer/Teta/Sprite".frame = 2
			checkDisturbe(0)
			currentCombo.append(0)
			checkGreekCombo()
		else:
			$"Zagadka-Grecka/Outer/Teta/Sprite".frame = 1

func greekPuzzleFi(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			$"Zagadka-Grecka/Outer/Fi/Sprite".frame = 2
			checkDisturbe(2)
			currentCombo.append(2)
			checkGreekCombo()
		else:
			$"Zagadka-Grecka/Outer/Fi/Sprite".frame = 1

func greekPuzzleDelta(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			$"Zagadka-Grecka/Outer/Delta/Sprite".frame = 2
			checkDisturbe(3)
			currentCombo.append(3)
			checkGreekCombo()
		else:
			$"Zagadka-Grecka/Outer/Delta/Sprite".frame = 1

func srobaClick(number, viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not scredriverActive:
			return
		$"Zagadka-Grecka/ScrewSound".play()
		var srobaHandler = $"Zagadka-Grecka/Outer".find_child("Sroba"+str(number))
		srobaHandler.find_child("Sprite").visible = false
		srobaHandler.find_child("CollisionShape2D").disabled = true
		srobaActiveList.erase(number)
		if srobaActiveList.is_empty():
			takeLidOff()

func takeLidOff():
	$"Zagadka-Grecka/Outer".visible = false
	$"Zagadka-Grecka/Baza".frame = 0

func buttonHighLight(letterName: String):
	var nodeSpriteHandler = $"Zagadka-Grecka".find_child(letterName).find_child("Sprite")
	if nodeSpriteHandler.frame != 2:
		nodeSpriteHandler.frame = 1
	
func buttonDeHighLight(letterName: String):
	$"Zagadka-Grecka".find_child(letterName).find_child("Sprite").frame = 0


var disturbeOn = false
var disturbeId = 0

func checkDisturbe(id: int):
	if not disturbeOn:
		return
	if not id == disturbeId:
		boom()
		return
	disturbeOn = false
	
func disturbeTimeOut(number: int):
	clockEnabled = false
	disturbeOn = true
	disturbeId = number-1
	$SecUnits.frame = 12
	$SecTens.frame = 12
	$MinUnits.frame = 12
	
	for i in range(1,6):
		if not disturbeOn:
			clockEnabled = true
			return
		$"MinTens".frame = numbersToGreek[number-1]
		$"Zagadka-Grecka/DisturbeLED".visible = true
		$"Zagadka-Grecka/DisturbeSound".play()
		await get_tree().create_timer(0.5).timeout
		$"MinTens".frame = 12
		$"Zagadka-Grecka/DisturbeLED".visible = false
		if not disturbeOn:
			clockEnabled = true
			return
		await get_tree().create_timer(0.5).timeout
	if disturbeOn:
		boom()
	clockEnabled = true

func checkGreekCombo():
	$"ClickSound".play()
	for i in range(0,currentCombo.size()):
		if not currentCombo.get(i) == greekCombo.get(i):
			currentCombo.clear()
			return
		if currentCombo.size() == greekCombo.size():
			ledCheckList.erase("Greek")
			ledCheckListChecker()

var drawerTrans = Vector2(0.0,58.0)
func openDrawer():
	$"Zagadka-Grecka/DrawerSound".play()
	$"Zagadka-Grecka/Drawer".visible = true
	move_object($"Zagadka-Grecka/Drawer", drawerTrans, 1.6)

func screwdriverHighlight():
	$"Zagadka-Grecka/Drawer/ScrewDriver/Sprite".frame = 1
	
func screwdriverDeHighlight():
	$"Zagadka-Grecka/Drawer/ScrewDriver/Sprite".frame = 0

var scredriverActive = false

func screwdriverClick(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		$"Zagadka-Grecka/Drawer/PickUp".play()
		$"Zagadka-Grecka/Drawer/ScrewDriver".visible = false
		scredriverActive = true

func screwHighlight(number: int):
	if scredriverActive:
		$"Zagadka-Grecka/Outer".find_child("Sroba"+str(number)).find_child("Sprite").frame = 1
	
func screwDeHighlight(number: int):
	$"Zagadka-Grecka/Outer".find_child("Sroba"+str(number)).find_child("Sprite").frame = 0
		
#####Telephone rotor puzzle#####
var isDragging = false
var startRotation = 0.0
var maxRotation = deg_to_rad(342)
var lastMouseAngle = 0.0
var canRotate = true

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

	if isDragging and canRotate:
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

var FourDigits = []

func stopDrag():
	if isDragging == true:
		var rotationAngle = rad_to_deg($"Zagadka-Tarcza/Sprite".rotation)
		var selectedNumber = ceil((rotationAngle-105.0)/25)
		if selectedNumber > 0:
			print(selectedNumber)
			playSound(selectedNumber)
			if not FourDigits.size() == 4:
				FourDigits.append(selectedNumber)
			renderX()
	isDragging = false

func renderX():
	$"Zagadka-Tarcza/Display".find_child(str(FourDigits.size())+"x").visible = true
	if FourDigits.size() == 4:
		canRotate = false
		await get_tree().create_timer(1.0).timeout
		checkCombo()
		
		for i in range(1,5):
			$"Zagadka-Tarcza/Display".find_child(str(i)+"x").visible = false
			
		$"Zagadka-Tarcza/Display/Calling".visible = true
		await get_tree().create_timer(2).timeout
		$"Zagadka-Tarcza/Display/Calling".visible = false
		canRotate = true

func checkCombo():
	if checkIfSame(FourDigits, [4,7,8,6]):
		ledCheckList.erase("Phone")
		ledCheckListChecker()
		$"Zagadka-Tarcza/LedYellow".visible = true
		$"Zagadka-Tarcza/Calling".play()
		return
	if checkIfSame(FourDigits, numbersToGreek):
		openDrawer()
		$"Zagadka-Tarcza/LedWhite".visible = true
		$"Zagadka-Tarcza/Calling".play()
		return
	$"Zagadka-Tarcza/Unavilable".play()
	FourDigits.clear()

func checkIfSame(check, combo) -> bool:
	for i in range(1,5):
		if not check.get(i) == combo.get(i):
			return false
	return true
		
func playSound(number: int):
	if number == 10:
		for i in range(0,6):
			$"Zagadka-Tarcza/ClackSound".play()
			await get_tree().create_timer(0.2).timeout
		return
	for i in range(0,number):
			$"Zagadka-Tarcza/ClackSound".play()
			await get_tree().create_timer(0.2).timeout

func rotorHighLight():
	$"Zagadka-Tarcza/Sprite".frame = 1

func rotorDeHighLight():
	$"Zagadka-Tarcza/Sprite".frame = 0
	stopDrag()

func clearButtonHighlight():
	$"Zagadka-Tarcza/Clear/Sprite".frame = 1
	
func clearButtonDeHighlight():
	$"Zagadka-Tarcza/Clear/Sprite".frame = 0

func clearButtonClick(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			$"ClickSound".play()
			FourDigits.clear()
			$"Zagadka-Tarcza/Clear/Sprite".frame=2
			for i in range(1,5):
				$"Zagadka-Tarcza/Display".find_child(str(i)+"x").visible = false
		else:
			$"Zagadka-Tarcza/Clear/Sprite".frame = 1

####Letter puzzle####
var letterShift = [1,3,4,0]
func letterOrientationButtonPress(number: int, orientation: String, viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		$"Zagadka-Litery".find_child(str(number)).find_child(orientation).find_child("Sprite").frame = 1
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		$"ClickSound".play()
		$"Zagadka-Litery".find_child(str(number)).find_child(orientation).find_child("Sprite").frame = 2
		var frame = $"Zagadka-Litery".find_child(str(number)).find_child("Sprite-Letter").frame
		if frame == 0 and orientation == "Down":
			$"Zagadka-Litery".find_child(str(number)).find_child("Sprite-Letter").frame = 25
			LetterTimerStart()
			return
		
		var plusOne = 1
		if orientation == "Down":
			plusOne = -1
		$"Zagadka-Litery".find_child(str(number)).find_child("Sprite-Letter").frame = (frame+plusOne)%26
		
		LetterTimerStart()

func letterOrientationButtonHighlight(number: int, orientation: String):
	$"Zagadka-Litery".find_child(str(number)).find_child(orientation).find_child("Sprite").frame = 1

func letterOrientationButtonDeHighlight(number: int, orientation: String):
	$"Zagadka-Litery".find_child(str(number)).find_child(orientation).find_child("Sprite").frame = 0
	
func turnDownLetters(state: bool):
	if state == true:
		for i in range(1, 5):
			var letter = ($"Zagadka-Litery".find_child(str(i)).find_child("Sprite-Letter").frame + letterShift[i-1])%26
			$"Zagadka-Litery".find_child(str(i)+"-Down").find_child("Sprite-Letter").frame = letter
		checkWord()
	for i in range(1, 5):
			$"Zagadka-Litery".find_child(str(i)+"-Down").find_child("Sprite-Letter").visible = state

func LetterTimerStart():
	$"Zagadka-Litery/LEDFlash".start()
	$"Zagadka-Litery/LetterTimer".start()

func onLetterTimerTimeout() -> void:
	$"Zagadka-Litery/LEDFlash".stop()
	turnDownLetters(true)
	await get_tree().create_timer(4.0).timeout
	turnDownLetters(false)

func onLEDFlashTimeout() -> void:
	$"Zagadka-Litery/LetterBip".play()
	$"Zagadka-Litery/LEDs/FlashTimer".visible = true
	await get_tree().create_timer(0.2).timeout
	$"Zagadka-Litery/LEDs/FlashTimer".visible = false
	
var wordAns = ["FUSE", "HELP", "OPEN", "FAIL"]
var wasItAnswerd = wordAns

func checkWord() -> void:
	await get_tree().create_timer(1.0).timeout
	var setLetters: String = ""
	for i in range(1,5):
		setLetters+=String.chr(65 + $"Zagadka-Litery".find_child(str(i)+"-Down").find_child("Sprite-Letter").frame)
	if not wordAns.find(setLetters) == -1:
		$"Zagadka-Litery/LEDs".find_child(str(wordAns.find(setLetters)+1)+"Ans").visible = true
		wasItAnswerd.erase(setLetters)
		if setLetters == "OPEN":
			openFlap()
		
		if wasItAnswerd.is_empty():
			ledCheckList.erase("Letter")
			ledCheckListChecker()
		return
		
	#Custom
	if setLetters == "BOOM":
		boom()
		return
		
	if setLetters == "LOOP":
		print("Loopty loop")
		return
	print(setLetters)


####Switches####
var flapTransform = Vector2(0.0, 133.0)
var switchCableBottomOutState = [0,0,0]


func openFlap():
	$"Zagadka-Grecka/DrawerSound".play()
	$"Zagadka-Switch/Base".visible = true
	move_object($"Zagadka-Switch/Flap", flapTransform, 1.6)
	await get_tree().create_timer(0.3).timeout
	$"Zagadka-Switch/Switches".visible=false
	await get_tree().create_timer(1.5).timeout
	checkSwitchCableBottom()

func checkSwitchCableBottom():
	var BottomSwitchState = [0,0,0,0,0,0]
	for i in range(1,6):
		if $"Zagadka-Switch/Switches".find_child("Switch"+str(i)).find_child("Sprite").frame == 2:
			$"Zagadka-Switch/Base/LEDs".find_child("R"+str(i)).visible = true
			BottomSwitchState.set(i, 1)
	await get_tree().create_timer(0.2).timeout
	##6
	if BottomSwitchState.get(1) and BottomSwitchState.get(3):
		blowCircut(6)
	switchCableBottomOutState.set(0, BottomSwitchState.get(1)^BottomSwitchState.get(3))
	$"Zagadka-Switch/Base/LEDs/R6".visible = switchCableBottomOutState.get(0)
	
	##7
	if BottomSwitchState.get(2) and BottomSwitchState.get(5):
		blowCircut(7)
	switchCableBottomOutState.set(1, BottomSwitchState.get(2)^BottomSwitchState.get(5))
	$"Zagadka-Switch/Base/LEDs/R7".visible = switchCableBottomOutState.get(1)

	##8
	if BottomSwitchState.get(3) and BottomSwitchState.get(4):
		blowCircut(8)
	switchCableBottomOutState.set(2, BottomSwitchState.get(3)^BottomSwitchState.get(4))
	$"Zagadka-Switch/Base/LEDs/R8".visible = switchCableBottomOutState.get(2)

	checkSwitchCableUpper()

var CircuitBurn = false
func blowCircut(number: int):
	$"Zagadka-Switch/Base/CableSplot".find_child("Splot"+str(number)).visible = true
	if CircuitBurn == false:
		$"Zagadka-Switch/Base/CirucitBurn".play()
		CircuitBurn = true

func checkSwitchCableUpper():
	var cableTurnOnCheck = ["1","2","3"]
	print(switchCableBottomOutState)
	print("Outer" + str(outerState))
	print("Inner" + str(innerState))
#O-I-Out
#1
#2-x-1  6-x-0  10-x-2  0-0-1  0-2-2  4-4-0  8-4-2  8-8-2  8-10-0
	if ((outerState == 2 and switchCableBottomOutState.get(1)) or
		(outerState == 6 and switchCableBottomOutState.get(0)) or
		(outerState == 10 and switchCableBottomOutState.get(2)) or
		(outerState == 0 and innerState == 0 and switchCableBottomOutState.get(1)) or 
		(outerState == 0 and innerState == 2 and switchCableBottomOutState.get(2)) or 
		(outerState == 4 and innerState == 4 and switchCableBottomOutState.get(0)) or 
		(outerState == 8 and innerState == 4 and switchCableBottomOutState.get(2)) or 
		(outerState == 8 and innerState == 8 and switchCableBottomOutState.get(2)) or 
		(outerState == 8 and innerState == 10 and switchCableBottomOutState.get(0))):
		$"Zagadka-Switch/Base/Outer/F1".visible = true
		cableTurnOnCheck.erase("1")
	else:
		$"Zagadka-Switch/Base/Outer/F1".visible = false
#2
#0-0-1  0-1-0  2-2-1  4-2-0  6-3-0  8-3-0  10-3-0  0-4-0  4-4-0  4-5-2  6-6-0
#8-6-2  0-7-2  2-7-2  10-7-2  4-8-2  8-8-2  8-9-2  10-0-1  10-10-2  2-11-1  4-11-1
	if ((outerState == 0 and innerState == 0 and switchCableBottomOutState.get(1)) or 
		(outerState == 0 and innerState == 1 and switchCableBottomOutState.get(0)) or 
		(outerState == 2 and innerState == 2 and switchCableBottomOutState.get(1)) or 
		(outerState == 4 and innerState == 2 and switchCableBottomOutState.get(0)) or 
		(outerState == 6 and innerState == 3 and switchCableBottomOutState.get(0)) or 
		(outerState == 8 and innerState == 3 and switchCableBottomOutState.get(0)) or 
		(outerState == 10 and innerState == 3 and switchCableBottomOutState.get(0)) or 
		(outerState == 0 and innerState == 4 and switchCableBottomOutState.get(0)) or 
		(outerState == 4 and innerState == 5 and switchCableBottomOutState.get(2)) or 
		(outerState == 6 and innerState == 6 and switchCableBottomOutState.get(0)) or 
		(outerState == 8 and innerState == 6 and switchCableBottomOutState.get(2)) or 
		(outerState == 0 and innerState == 7 and switchCableBottomOutState.get(2)) or 
		(outerState == 2 and innerState == 7 and switchCableBottomOutState.get(2)) or 
		(outerState == 10 and innerState == 7 and switchCableBottomOutState.get(2)) or 
		(outerState == 4 and innerState == 8 and switchCableBottomOutState.get(2)) or 
		(outerState == 8 and innerState == 8 and switchCableBottomOutState.get(2)) or 
		(outerState == 8 and innerState == 9 and switchCableBottomOutState.get(2)) or 
		(outerState == 10 and innerState == 0 and switchCableBottomOutState.get(1)) or 
		(outerState == 10 and innerState == 10 and switchCableBottomOutState.get(2)) or 
		(outerState == 2 and innerState == 11 and switchCableBottomOutState.get(1)) or 
		(outerState == 4 and innerState == 11 and switchCableBottomOutState.get(1))):
		$"Zagadka-Switch/Base/LEDs/F2".visible = true
		cableTurnOnCheck.erase("2")
	else:
		$"Zagadka-Switch/Base/LEDs/F2".visible = false
#3
#0-0-2  10-0-2  6-2-0  8-4-2  6-6-0  8-8-2  2-9-2  8-10-0  10-10-0
	if ((outerState == 0 and innerState == 0 and switchCableBottomOutState.get(2)) or 
		(outerState == 10 and innerState == 0 and switchCableBottomOutState.get(2)) or 
		(outerState == 6 and innerState == 2 and switchCableBottomOutState.get(0)) or 
		(outerState == 8 and innerState == 4 and switchCableBottomOutState.get(2)) or 
		(outerState == 6 and innerState == 6 and switchCableBottomOutState.get(0)) or 
		(outerState == 8 and innerState == 8 and switchCableBottomOutState.get(2)) or 
		(outerState == 2 and innerState == 9 and switchCableBottomOutState.get(2)) or 
		(outerState == 8 and innerState == 10 and switchCableBottomOutState.get(0)) or 
		(outerState == 10 and innerState == 10 and switchCableBottomOutState.get(0))):
		$"Zagadka-Switch/Base/LEDs/F3".visible = true
		cableTurnOnCheck.erase("3")
	else:
		$"Zagadka-Switch/Base/LEDs/F3".visible = false
	
	if cableTurnOnCheck.is_empty():
		ledCheckList.erase("Switch")
		ledCheckListChecker()
	

func move_object(objectToMove, offset: Vector2, duration: float = 1.0):
	var targetPosition = objectToMove.position + offset
	var tween = create_tween()
	tween.tween_property(objectToMove, "position", targetPosition, duration)

func switchHighLight(number: int):
	var node = $"Zagadka-Switch/Switches".find_child("Switch"+str(number)).find_child("Sprite")
	node.frame += 1

func switchDeHighLight(number: int):
	var node = $"Zagadka-Switch/Switches".find_child("Switch"+str(number)).find_child("Sprite")
	node.frame -= 1

func switchClick(number: int, viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var node = $"Zagadka-Switch/Switches".find_child("Switch"+str(number))
		$"Zagadka-Switch/Switches/SwitchClick".play()
		
		var nodeTrans = node.position
		node.find_child("Sprite").frame = (node.find_child("Sprite").frame+2)%4
		if node.find_child("Sprite").frame < 2:
			node.set_position(node.position-Vector2(0.0, 25.0))
		else:
			node.set_position(node.position+Vector2(0.0, 25.0))

func OuterRotorHighLight():
	$"Zagadka-Switch/Base/Outer/Sprite".frame = 1

func OuterRotorDeHighLight():
	$"Zagadka-Switch/Base/Outer/Sprite".frame = 0

func InnerRotorHighLight():
	$"Zagadka-Switch/Base/Inner/Sprite".frame = 3
	$"Zagadka-Switch/Base/Outer/Sprite".frame = 0

func InnerRotorDeHighLight():
	$"Zagadka-Switch/Base/Inner/Sprite".frame = 2
	$"Zagadka-Switch/Base/Outer/Sprite".frame = 1

var outerState = 0
var innerState = 0

func OuterRotorClick(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT):
		var space_state = get_world_2d().direct_space_state
		var space = PhysicsServer2D.space_get_direct_state(get_world_2d().get_space())
		var parameters = PhysicsPointQueryParameters2D.new()
		parameters.position= get_viewport().get_mouse_position()
		parameters.collide_with_areas = true
		parameters.collide_with_bodies = false
		parameters.collision_mask = 2
		var result = space.intersect_point(parameters)
		
		if result.size() > 0:
			return
			
		var node = $"Zagadka-Switch/Base/Outer"
		if event.button_index == MOUSE_BUTTON_LEFT:
			outerState = (outerState+1)%12
			node.rotation_degrees = (int(node.rotation_degrees)+30)%360
		else:
			outerState = (outerState-1)%12
			if node.rotation_degrees == 0:
				node.rotation_degrees = 330
				outerState = 11
				return
			node.rotation_degrees = (int(node.rotation_degrees)-30)%360
		#$"Zagadka-Switch/Base/Outer/F1".global_rotation_degrees = 0.0
		$"Zagadka-Tarcza/ClackSound".play()
		checkSwitchCableUpper()


func InnerRotorClick(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT):
		var node = $"Zagadka-Switch/Base/Inner"
		if event.button_index == MOUSE_BUTTON_LEFT:
			innerState = (innerState+1)%12
			node.rotation_degrees = (int(node.rotation_degrees)+30)%360
		else:
			innerState = (innerState-1)%12
			if node.rotation_degrees == 0:
				node.rotation_degrees = 330
				innerState = 11
				return
			node.rotation_degrees = (int(node.rotation_degrees)-30)%360
		$"Zagadka-Tarcza/ClackSound".play()
		checkSwitchCableUpper()


####Timer Cable####
func cableCut(name: String, viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		$"TimerCables".find_child(name).find_child("Sprite").frame = 2
		$"TimerCables".find_child(name).find_child("CollisionPolygon2D").disabled = true
		$"TimerCables/CableCut".play()
		if name == "White":
			var whiteTime = 230
			if floor($"Timer".time_left) == whiteTime:
				cableCheckList.erase("White")
				checkCable()
				return
			if ledCheckList.find("Greek") == -1:
				showTime(whiteTime)
				return
			boom()
		if name == "Yellow":
			var yellowTime = 130
			if floor($"Timer".time_left) == yellowTime:
				cableCheckList.erase("Yellow")
				checkCable()
				return
			if ledCheckList.find("Phone") == -1:
				showTime(yellowTime)
				return
			boom()
		if name == "Purple":
			var purpleTime = 40
			if floor($"Timer".time_left) == purpleTime:
				cableCheckList.erase("Purple")
				checkCable()
				return
			if ledCheckList.find("Switch") == -1:
				showTime(purpleTime)
				return
			boom()
		if name == "Pink":
			var pinkTime = 170
			if floor($"Timer".time_left) == pinkTime:
				cableCheckList.erase("Pink")
				checkCable()
				return
			if ledCheckList.find("Letter") == -1:
				showTime(pinkTime)
				return
			boom()
	
func showTime(time):
	clockEnabled = false
	var seconds = time % 60
	var minutes = int(time / 60)
	$"MinTens".frame = 12
	for i in range(0, 3):
		$SecUnits.frame = seconds % 10
		$SecTens.frame = int(seconds / 10)
		$MinUnits.frame = minutes % 10
		await get_tree().create_timer(0.5).timeout
		$SecUnits.frame = 12
		$SecTens.frame = 12
		$MinUnits.frame = 12
		await get_tree().create_timer(0.5).timeout
	boom()

func checkCable():
	print(cableCheckList)
	if cableCheckList.is_empty():
		win()

func cableHighlight(name: String):
	$"TimerCables".find_child(name).find_child("Sprite").frame = 1

func cableDeHighlight(name: String):
	if not $"TimerCables".find_child(name).find_child("Sprite").frame == 2:
		$"TimerCables".find_child(name).find_child("Sprite").frame = 0
