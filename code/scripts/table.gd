extends Node2D

var selected_bomb:float = 0.0
func _ready() -> void:
	$Bomb1.set_visible(false)

func start_bomb(bombNumber):
	if bombNumber == 1:
		$Bomb1.set_visible(true)
		$Bomb1.startTimer()
	if bombNumber == 2:
		pass
