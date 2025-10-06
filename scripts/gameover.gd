extends Control

signal reset()

func update()->void:
	$"../station_direction".hide()
	$"../healthbar".hide()
	$"../Score".hide()
	$Timer.start()
	
func _process(_delta: float)->void:
	if (Input.is_anything_pressed() or Input.is_action_just_pressed("Boost") or Input.is_action_just_pressed("TractorBeam") or Input.is_action_just_pressed("TurnL") or Input.is_action_just_pressed("TurnR")) and not hidden and $Timer.is_stopped():
		$"../InitHud".show()
		$"../InitHud/Timer".start()
		reset.emit()
		for c in get_tree().get_nodes_in_group("Scrap"):
			c.queue_free()
		get_tree().paused = true
		hide()
