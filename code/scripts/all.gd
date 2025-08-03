extends Node2D

func _ready():
	if Global.skipCutscene == true:
		if Global.tutorialBombDefused == false:
			$Bomb1.visible = true
			Global.tutorialBombDefused = true
		else:
			$Bomb2.visible = true
		if Global.bombDefused == true:
			$Bomb1.visible = false
			$Bomb2.visible = false
			$WinScreen.visible = true
	else:
		$Notatka.visible = true
		Global.skipCutscene = true
	$Bomb1.connect("input_event", Callable(self, "_on_Bomb1Collision_input_event"))
	$Bomb2.connect("input_event", Callable(self, "_on_Bomb2Collision_input_event"))
	$Notatka.connect("input_event", Callable(self, "_on_NotatkaCollision_input_event"))
	$List.connect("input_event", Callable(self, "_on_ListCollision_input_event"))
	
func _on_NotatkaCollision_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		$Notatka.visible = false
		$List.visible = true

func _on_ListCollision_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		$List.visible = false
		$Bomb1.visible = true
		$Bomb2.visible = true

func _on_Bomb1Collision_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().change_scene_to_file("res://level/scene/table1.tscn")

		
func _on_Bomb2Collision_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().change_scene_to_file("res://level/scene/table2.tscn")
		
