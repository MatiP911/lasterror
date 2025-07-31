extends Node2D

var selected_bomb = 0

func _ready() -> void:
	$all.set_visible(true)
	$table.set_visible(false)
	$all.bomb_clicked.connect(_bomb_clicked)

func _bomb_clicked(bomb_number):
	selected_bomb = bomb_number
	$all.set_visible(false)
	$table.set_visible(true)
	$table.start_bomb(selected_bomb)
