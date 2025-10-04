extends Area2D

func _process(_delta: float) -> void:
	$Label.text = str(int(round($Timer.time_left)))


func _on_timer_timeout() -> void:
	position = Vector2(randf_range(-500,500), randf_range(-500,500))


func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		$"../ScrapSpawner".score(1)
		body.queue_free()
