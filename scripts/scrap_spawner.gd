extends Node2D

const SCRAP_OPTIONS = [
		preload("res://scenes/scrap1.tscn"),
		preload("res://scenes/scrap_antenna.tscn"),
		preload("res://scenes/scrap_player.tscn"), 
		preload("res://scenes/scrap_satellite2.tscn"),
		preload("res://scenes/scrap_satellite1.tscn")
	]
	
const CREATE_RADIUS = 600
const CREATE_VISUAL_RADIUS = 500

signal on_score(pts: int)

func create_scrap()->void:
	var new_scrap: RigidBody2D = SCRAP_OPTIONS[randi() % len(SCRAP_OPTIONS)].instantiate()
	var thau: float = randf() * 2 * PI
	var target: Vector2 = $"../Station".position
	if (randi() % 2 == 0): target = $"../Player".position
	
	new_scrap.position.x = CREATE_RADIUS * cos(thau) + target.x
	new_scrap.position.y = CREATE_RADIUS * sin(thau) + target.y
	
	if ($"../Station".position - new_scrap.position).length() < CREATE_VISUAL_RADIUS or ($"../Player".position - new_scrap.position).length() < CREATE_VISUAL_RADIUS:
		return
	
	new_scrap.rotation = randf() * 2 * PI
	new_scrap.gravity_scale = 0
	new_scrap.physics_material_override = preload("res://assets/scrap/scrap_physics.tres")
	
	new_scrap.apply_central_impulse(((target - new_scrap.position).normalized().rotated(randf() * 2-1)) * ((randf() * 60)+10))
	new_scrap.set_script(preload("res://scripts/scrap.gd"))
	add_child(new_scrap)
	print("Scrap added at ", new_scrap.position)

func _on_timer_timeout() -> void:
	$Timer.wait_time = max($Timer.wait_time-0.01, 0.5)
	create_scrap()

func score(pts: int):
	on_score.emit(pts)
