extends AudioStreamPlayer

func  _ready() -> void:
	playing = true

func _on_music_toggled(toggled_on: bool) -> void:
	playing = toggled_on
