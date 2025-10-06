extends Control

signal reset()

func update()->void:
	$"../station_direction".hide()
	$"../healthbar".hide()
	$"../Score".hide()
	$Timer.start()
	get_tree().paused = true
	
func _process(_delta: float)->void:
	if visible and (Input.is_action_just_pressed("Boost") or Input.is_action_just_pressed("TractorBeam") or Input.is_action_just_pressed("TurnL") or Input.is_action_just_pressed("TurnR") or Input.is_action_just_pressed("Pause")):
		print("triggered")
		$"../InitHud".show()
		$"../InitHud".init()
		$"../InitHud/TextureRect".texture = preload("res://assets/ui/Overlay.png")
		reset.emit()
		for c in get_tree().get_nodes_in_group("Scrap"):
			c.queue_free()
		get_tree().paused = true
		hide()
