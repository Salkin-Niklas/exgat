extends AnimatedSprite2D


func _on_player_health_changed(health: int) -> void:
	animation = str(max(min(health, 4), 0))
