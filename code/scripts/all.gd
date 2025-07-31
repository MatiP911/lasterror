extends Node2D

func _ready():
	$Bomb1.connect("input_event", Callable(self, "_on_Bomb1Collision_input_event"))
	$Bomb2.connect("input_event", Callable(self, "_on_Bomb2Collision_input_event"))


func _on_Bomb1Collision_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().change_scene_to_file("res://level/scene/table1.tscn")

		
func _on_Bomb2Collision_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().change_scene_to_file("res://level/scene/all.tscn")
		
