extends Node2D

var bombNode: Node2D

func _ready() -> void:
	$Bomb2.connect("explosion", Callable(self, "boom"))
	bombNode = $Bomb2
	
	$BackArrow.connect("input_event", Callable(self, "backArrowClick"))
	$Bomb2.connect("defused", Callable(self, "defuse"))

func boom():
	$BoomAnimation.visible = true
	$BoomAnimation.play()
	$"BoomSound".play()
	await get_tree().create_timer(0.2).timeout
	
	var nodeTrans = bombNode.position
	
	bombNode.queue_free()
	bombNode = preload("res://level/object/bomb2.tscn").instantiate()
	add_child(bombNode)
	
	bombNode.set_position(nodeTrans)
	bombNode.connect("explosion", Callable(self, "boom"))
	bombNode.connect("defused", Callable(self, "defuse"))
	
func defuse():
	$WinScreen.visible = true
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://level/scene/all.tscn")

func onBoomAnimationEnd():
	$BoomAnimation.visible = false

func backArrowClick(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().change_scene_to_file("res://level/scene/all.tscn")

func backArrowHighLight():
	$"BackArrow/Sprite".frame = 1

func backArrowDeHighLight():
	$"BackArrow/Sprite".frame = 0
	
