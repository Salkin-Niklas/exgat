extends TextureButton

func _ready() -> void:
	AudioServer.set_bus_layout(preload("res://sfx/audio_busses.tres"))

func _on_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(1, toggled_on)
