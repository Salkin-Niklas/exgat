extends Label

var points: int = 0

func _on_scrap_spawner_on_score(pts: int) -> void:
	points += pts
	text = str(points)


func _on_gameover_reset() -> void:
	points = 0
	text = "0"
