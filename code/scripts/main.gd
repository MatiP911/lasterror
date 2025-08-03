extends Node2D

var menuActive = true
func _ready() -> void:
	$"Menu/Start".connect("input_event", Callable(self, "startClick"))
	$"Menu/Credits".connect("input_event", Callable(self, "creditsClick"))
	$"Menu/Quit".connect("input_event", Callable(self, "quitClick"))
	$"Credits/Back".connect("input_event", Callable(self, "backClick"))

func menuButtonHighLight(name: String):
	if menuActive:
		$"Menu".find_child(name).find_child("Sprite").visible = true

func menuButtonDeHighLight(name: String):
	if menuActive:
		$"Menu".find_child(name).find_child("Sprite").visible = false

func startClick(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and menuActive:
		menuActive = false
		fadeOut($Fade, 1.0)
		await fadeOut($Menu, 1.0)
		$Menu.visible = false
		get_tree().change_scene_to_file("res://level/scene/all.tscn")

func creditsClick(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and menuActive:
		menuActive = false
		fadeOut($Menu, 1.0)
		$Menu.visible = false
		fadeIn($Menu, 1.0)
		$Credits.visible = true
		

func quitClick(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and menuActive:
		get_tree().quit()


func fadeOut(node: CanvasItem, duration: float = 1.0) -> void:
	var startAlpha = node.modulate.a
	var timePassed = 0.0
	
	while timePassed < duration:
		var t = timePassed / duration
		var newAlpha = lerp(startAlpha, 0.0, t)
		node.modulate.a = newAlpha
		await get_tree().process_frame
		timePassed += get_process_delta_time()
	
	node.modulate.a = 0.0

func fadeIn(node: CanvasItem, duration: float = 1.0) -> void:
	node.modulate.a = 0.0
	var timePassed = 0.0
	
	while timePassed < duration:
		var t = timePassed / duration
		var newAlpha = lerp(0.0, 1.0, t)
		node.modulate.a = newAlpha
		await get_tree().process_frame
		timePassed += get_process_delta_time()
	
	node.modulate.a = 1.0 

func backHighlight():
	$"Credits/Back/Sprite".visible = true


func backDeHighlight():
	$"Credits/Back/Sprite".visible = false

func backClick(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		$"Menu".visible = true
		fadeOut($Credits, 0.3)
		await fadeIn($Menu, 0.3)
		$Credits.visible = false
		menuActive = true

func musicLoop():
	await get_tree().create_timer(1.3).timeout
	$"Music".play()
