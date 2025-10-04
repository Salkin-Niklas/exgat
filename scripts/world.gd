extends Node2D

@onready var player: CharacterBody2D = $Game/Player
@onready var station: Area2D = $Game/Station

func _process(delta: float) -> void:
	# Direction pointer to the station
	var viewport_rect := get_viewport_rect().size
	var dir := station.global_position-player.global_position
	
	var m :float = (station.global_position.y-player.global_position.y)/(station.global_position.x-player.global_position.x)
	var b :float = player.global_position.y - m*player.global_position.x
	var y: float = 0
	if Vector2.UP.dot(dir)>0:
		y = player.global_position.y -viewport_rect.y/2+60
	else:
		y = player.global_position.y +viewport_rect.y/2-60
	var x: float = 0
	if Vector2.RIGHT.dot(dir)>0:
		x = player.global_position.x +viewport_rect.x/2-60
	else:
		x = player.global_position.x -viewport_rect.x/2+60
	
	var pos: Vector2
	pos = Vector2((y-b)/m,y)
	if is_nan(pos.x):
		pos.x = 0
	var bb: Rect2 = Rect2(player.global_position.x -viewport_rect.x/2+60, player.global_position.y -viewport_rect.y/2+60, viewport_rect.x-119, viewport_rect.y-119)
	if !bb.has_point(pos):
		pos = Vector2(x,m*x+b)
	
	$GUI/station_direction.position = $GUI/station_direction.position.lerp(pos-player.global_position+viewport_rect/2, delta*4)
	$GUI/station_direction/Sprite2D.rotation = (pos-player.global_position).angle_to(Vector2.UP)
	
	if (pos-player.global_position).length()>(dir.length()-120):
		$GUI/station_direction.hide()
	else:
		$GUI/station_direction.show()
