extends Node2D

var bombNode: Node2D

func _ready() -> void:
	$Bomb2.connect("explosion", Callable(self, "boom"))
	bombNode = $Bomb2

func boom():
	$BoomAnimation.visible = true
	$BoomAnimation.play()
	await get_tree().create_timer(0.2).timeout
	
	var nodeTrans = bombNode.position
	
	bombNode.queue_free()
	bombNode = preload("res://level/object/bomb2.tscn").instantiate()
	get_parent().add_child(bombNode)
	
	bombNode.set_position(nodeTrans)
	bombNode.connect("explosion", Callable(self, "boom"))
	

func onBoomAnimationEnd():
	$BoomAnimation.visible = false
