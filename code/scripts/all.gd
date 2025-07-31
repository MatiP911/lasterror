extends Node2D

signal bomb_clicked

func _ready():
	$Bomb1.connect("input_event", Callable(self, "_on_Bomb1Collision_input_event"))
	$Bomb2.connect("input_event", Callable(self, "_on_Bomb2Collision_input_event"))


func _on_Bomb1Collision_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("bomb_clicked", 1.0)
		
func _on_Bomb2Collision_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("bomb_clicked", 2.0)
		
