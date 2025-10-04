extends Label

var points: int = 0

func _on_scrap_spawner_on_score(pts: int) -> void:
	points += pts
	text = str(points)
