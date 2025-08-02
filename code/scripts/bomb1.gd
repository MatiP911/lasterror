extends Node2D

@export var bombDefuseTime = 25
@export var LEDTimerMoment = 4

var timerEnable = true

var puzzle1RotorPos = 1
var defuseCheckList = [
	"timercable1",
	"puzzle1Cable1",
	"puzzle1Cable2",
	"puzzle1Cable3",
	"puzzle1Cable4"]

func _ready() -> void:
	$Timer.start(bombDefuseTime)
	$Dots.play()

	$CableTimer1.connect("input_event", Callable(self, "cableTimer1Cut"))
	$Puzzle1/Cable1.connect("input_event", Callable(self, "puzzle1Cable1Cut"))
	$Puzzle1/Cable2.connect("input_event", Callable(self, "puzzle1Cable2Cut"))
	$Puzzle1/Cable3.connect("input_event", Callable(self, "puzzle1Cable3Cut"))
	$Puzzle1/Cable4.connect("input_event", Callable(self, "puzzle1Cable4Cut"))
	$Puzzle1/Rotor.connect("input_event", Callable(self, "puzzle1RotorClick"))
	$BoomButton.connect("input_event", Callable(self, "boomButtonPress"))
	$Timer.connect("timeout", Callable(self, "boom"))
	
	$"LEDGlow/LEDTimer".start(bombDefuseTime-LEDTimerMoment-1)

func _process(delta: float) -> void:
	checkTime()

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
		timerEnable=false
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
	
	if timerEnable:
		$SecUnits.frame = seconds % 10
		$SecTens.frame = int(seconds / 10)
		$MinUnits.frame = minutes % 10

func puzzle1RotorClick(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			puzzle1RotorPos=(puzzle1RotorPos+1)%3
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if puzzle1RotorPos == 0:
				puzzle1RotorPos = 2
			else:
				puzzle1RotorPos=(puzzle1RotorPos-1)%3
		else: 
			return
		print("Rotor")
		if puzzle1RotorPos==0:
			$Puzzle1/Rotor/Sprite.rotation_degrees = -48.0
		if puzzle1RotorPos==1:
			$Puzzle1/Rotor/Sprite.rotation_degrees = 0.0
		if puzzle1RotorPos==2:
			$Puzzle1/Rotor/Sprite.rotation_degrees = 48.0

#### Cuting cables ####
func changeToBroken(node: Area2D) -> void:
	node.find_child("Sprite").frame = 2
	node.find_child("CollisionPolygon2D").disabled = true

func highlightCable(node: Area2D) -> void:
	if node.find_child("Sprite").frame != 2:
		node.find_child("Sprite").frame = 1
	
func dehighlightCable(node: Area2D) -> void:
	if node.find_child("Sprite").frame != 2:
		node.find_child("Sprite").frame = 0

func puzzle1Cable1Cut(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("cut puzzle1Cable1Cut")
			changeToBroken($Puzzle1/Cable1)
			if puzzle1RotorPos != 0:
				boom()
			else:
				defuseCheckList.erase("puzzle1Cable1")

func puzzle1Cable2Cut(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("cut puzzle1Cable2Cut")
			changeToBroken($Puzzle1/Cable2)
			if puzzle1RotorPos != 1:
				boom()
			else:
				defuseCheckList.erase("puzzle1Cable2")
				
func puzzle1Cable3Cut(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("cut puzzle1Cable3Cut")
			changeToBroken($Puzzle1/Cable3)
			if puzzle1RotorPos != 2:
				boom()
			else:
				defuseCheckList.erase("puzzle1Cable3")
				
func puzzle1Cable4Cut(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("cut puzzle1Cable4Cut")
			changeToBroken($Puzzle1/Cable4)
			if puzzle1RotorPos != 1:
				boom()
			else:
				defuseCheckList.erase("puzzle1Cable4")

####LED####
var canCutTimer = false
func cableTimer1Cut(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("cut cableTimer1Cut")
			changeToBroken($CableTimer1)
			if not canCutTimer:
				boom()
				return
			defuseCheckList.erase("timercable1")
			
func LedTimerTimeOut():
	canCutTimer = true
	$"LEDGlow/Sprite2D".visible = true
	await get_tree().create_timer(1.0).timeout
	$"LEDGlow/Sprite2D".visible = false
	canCutTimer = false

#####HighLights#####
func _on_cable_timer_1_mouse_entered() -> void:
	highlightCable($CableTimer1)
func _on_cable_timer_1_mouse_exited() -> void:
	dehighlightCable($CableTimer1)

func _on_rotor_mouse_entered() -> void:
	$Puzzle1/Rotor/Sprite.frame=1
func _on_rotor_mouse_exited() -> void:
	$Puzzle1/Rotor/Sprite.frame=0

func _on_cable_1_mouse_entered() -> void:
	highlightCable($Puzzle1/Cable1)
func _on_cable_1_mouse_exited() -> void:
	dehighlightCable($Puzzle1/Cable1)

func _on_cable_2_mouse_entered() -> void:
	highlightCable($Puzzle1/Cable2)
func _on_cable_2_mouse_exited() -> void:
	dehighlightCable($Puzzle1/Cable2)

func _on_cable_3_mouse_entered() -> void:
	highlightCable($Puzzle1/Cable3)
func _on_cable_3_mouse_exited() -> void:
	dehighlightCable($Puzzle1/Cable3)

func _on_cable_4_mouse_entered() -> void:
	highlightCable($Puzzle1/Cable4)
func _on_cable_4_mouse_exited() -> void:
	dehighlightCable($Puzzle1/Cable4)

func _on_boom_button_mouse_entered() -> void:
	$BoomButton/Sprite.frame = 1
func _on_boom_button_mouse_exited() -> void:
	$BoomButton/Sprite.frame = 0
