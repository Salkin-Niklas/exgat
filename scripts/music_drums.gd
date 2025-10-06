extends AudioStreamPlayer

const MUTE_SPEED = 100

func  _ready() -> void:
	playing = true

func _on_music_toggled(toggled_on: bool) -> void:
	playing = toggled_on
	
func _process(delta: float) -> void:
	volume_db = clampf(volume_db + int(get_tree().paused)*delta*MUTE_SPEED, -16, -8.6)


func _on_finished() -> void:
	play()
