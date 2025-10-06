extends Control

func _ready() -> void:
	init()

func init() -> void:
	show()
	get_tree().paused = true
	$"../healthbar".hide()
	$"../station_direction".hide()
	$"../Score".hide()
	$Timer.start()
	print("InitHUD called")
	
func _process(_delta: float) -> void:
	if visible and (Input.is_action_just_pressed("Boost") or\
		Input.is_action_just_pressed("TractorBeam") or\
		Input.is_action_just_pressed("TurnL") or\
		Input.is_action_just_pressed("TurnR")):
		get_tree().paused = false
		$"../healthbar".show()
		$"../Score".show()
		$TextureRect.texture = preload("res://assets/ui/Overlay_continue.png")
		hide()
		print("unpaused")
	#if  (Input.is_action_just_pressed("Boost") or Input.is_action_just_pressed("TractorBeam") or Input.is_action_just_pressed("TurnL") or Input.is_action_just_pressed("TurnR") or Input.is_key_pressed(KEY_ESCAPE)):
	#		get_tree().paused = false
	#		$"../healthbar".show()
	#		$"../station_direction".show()
	#		$"../Score".show()
	#		$TextureRect.texture = preload("res://assets/ui/Overlay_continue.png")
	#		hide()


func _on_player_pause_requested() -> void:
	init()
