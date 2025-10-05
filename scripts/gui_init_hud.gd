extends Control

func _ready() -> void:
	show()
	get_tree().paused = true
	$"../healthbar".hide()
	$"../station_direction".hide()
	$"../Score".hide()
	$Timer.start()
	
func _process(_delta: float) -> void:
	if  Input.is_key_pressed(KEY_SPACE) or \
		Input.is_key_pressed(KEY_W) or  \
		Input.is_key_pressed(KEY_A) or \
		Input.is_key_pressed(KEY_D) or \
		Input.is_key_pressed(KEY_ESCAPE) and $Timer.is_stopped():
			get_tree().paused = false
			$"../healthbar".show()
			$"../station_direction".show()
			$"../Score".show()
			$TextureRect.texture = preload("res://assets/ui/Overlay_continue.png")
			hide()
