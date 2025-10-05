extends Area2D

@export var n1: Vector2 = Vector2(0,0)
@export var n2: Vector2 = Vector2(20,0)
@export var n3: Vector2 = Vector2(20,20)
@export var n4: Vector2 = Vector2(0,20)

@export var curve: Curve
@export var curve_gravity: float = 2
@export var mesh_points: int = 5

func update(line_points: int = 23)->void:
	$CollisionPolygon2D.polygon = PackedVector2Array([n1,n2,n3,n4])
	$N1.position = n1
	$N2.position = n2
	$N3.position = n3
	$N4.position = n3
	$Line_outer.clear_points()
	var dist: float = 1./mesh_points
	
	for idx in range(4):
		var n: Vector2  = [n1,n2,n3,n4][idx]
		var ng: Vector2 =  [n2,n3,n4,n1][idx]
		for i in range(mesh_points+1):
			line_points -= 1
			if line_points < 1: return
			$Line_outer.add_point(lerp(n,ng,dist*i)+Vector2(0,curve_gravity*curve.sample(dist*i)))
			
	for i in range(1, mesh_points, 2):
		var n = $Line_outer.get_point_position(i)
		var ng = $Line_outer.get_point_position(mesh_points*3-i+2)
		for j in range(mesh_points+1):
			line_points -= 1
			if line_points < 1: return
			$Line_outer.add_point(lerp(n,ng,dist*j)+Vector2(0,curve_gravity*curve.sample(dist*j)))
		n = $Line_outer.get_point_position(mesh_points*3-i+1)
		ng = $Line_outer.get_point_position(i+1)
		for j in range(mesh_points+1):
			line_points -= 1
			if line_points < 1: return
			$Line_outer.add_point(lerp(n,ng,dist*j)+Vector2(0,curve_gravity*curve.sample(dist*j)))
	
	line_points -= 1
	if line_points < 1: return
	$Line_outer.add_point(n2)
	#$N5.position = $Line_outer.get_point_position(mesh_points*2)
	for i in range(0, mesh_points, 2):
		var n = $Line_outer.get_point_position(mesh_points+i+2)
		var ng = $Line_outer.get_point_position(mesh_points*5-i-3)
		for j in range(mesh_points+1):
			line_points -= 1
			if line_points < 1: return
			$Line_outer.add_point(lerp(n,ng,dist*j)+Vector2(0,curve_gravity*curve.sample(dist*j)))
		n = $Line_outer.get_point_position(mesh_points*5-i-4)
		ng = $Line_outer.get_point_position(mesh_points+i+3)
		for j in range(mesh_points+1):
			line_points -= 1
			if line_points < 1: return
			$Line_outer.add_point(lerp(n,ng,dist*j)+Vector2(0,curve_gravity*curve.sample(dist*j)))
