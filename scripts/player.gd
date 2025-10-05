extends CharacterBody2D

const TURNING_SPEED: float = 1.6
const FRICTION: float = 0.1 # TODO implement ?
const BOOST_FORCE: float = 100
const BREAK_FORCE: float = 150

var health: float = 100.0

var trapped_debris: Array[RigidBody2D] = []

@export var line2d: Line2D
@export var line2d2: Line2D
# Maximum number of points in the trail
@export var trail_max_points: int = 10
# Distance between points
@export var trail_point_spacing: float = 1
# Used to control the spacing between trail points
var distance_accum: float = 0.0

signal health_changed(health: int)
signal pause_requested()

func _physics_process(delta: float) -> void:
	var base: String = "idle"
	if Input.is_action_pressed("Boost"):
		var normal = Vector2(cos(rotation+PI/2), sin(rotation+PI/2))
		var break_boost = (normal.dot(velocity.normalized()) + 1) * BREAK_FORCE / 2
		#print(normal.dot(velocity.normalized()))
		velocity.x += (BOOST_FORCE+break_boost)*delta * sin(rotation)
		velocity.y -= (BOOST_FORCE+break_boost)*delta * cos(rotation)
		base = "boost"
	if Input.is_action_pressed("TurnL"):
		rotation -= TURNING_SPEED*delta
		base += "R"
	elif Input.is_action_pressed("TurnR"):
		rotation += TURNING_SPEED*delta
		base += "L"
		
	if Input.is_key_pressed(KEY_ESCAPE):
		$"../../GUI/InitHud".show()
		pause_requested.emit()
		
	$eninge_sound.stream_paused = base == "idle"
		
	move_and_slide()
	if randi() % 2 == 0:
		$Sprite.animation = base
	else: $Sprite.animation = "idle"
	
	# after calling move_and_slide()
	for i in get_slide_collision_count():
		var c := get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			#var impulse: Vector2 = Vector2(sin(rotation), -cos(rotation))#-c.get_normal()/Vector2(sin(rotation), cos(rotation)) #* velocity.length()/10
			##impulse 
			#c.get_collider().apply_impulse(impulse, c.get_position())
			###if impulse.length() > 10 and $HitEffectTimeout.is_stopped():
			
			var damage: float = abs(c.get_collider().linear_velocity.dot(c.get_normal())) + abs(self.velocity.dot(c.get_normal())) / 5
			print("damaged by ", damage)
			if damage < 5.0 or not $HitEffectTimeout.is_stopped():
				damage = 0.0
			else:
				$HitEffectTimeout.start()
				$Sprite.modulate = Color(2,2,2)
			#print(damage)
			health-= damage
			health_changed.emit(health/25)

	if Input.is_action_pressed("TractorBeam"):
		$Tractor.monitoring = true
		$beam_sound.stream_paused = false
		$Tractor.show()
	else:
		$Tractor.monitoring = false
		$beam_sound.stream_paused = true
		$Tractor.hide()
	if $Tractor.monitoring == true:
		for d in trapped_debris:
			var force: Vector2 = Vector2(0,0)
			force -= (d.global_position-(global_position+Vector2(0,-85).rotated(rotation)))*10
			force -= (d.linear_velocity-velocity)*100
			#print(d.linear_velocity)
			d.apply_central_force(force)
		#print(velocity)

	var trail_pos   = to_global(Vector2(18,25))
	var trail_pos_2 = to_global(Vector2(-18,25))
	# Calculate the distance from the last point to the current mouse position
	if line2d.get_point_count() > 0:
		var last_point = line2d.get_point_position(line2d.get_point_count() - 1)
		var distance = trail_pos.distance_to(last_point)
		distance_accum += distance
	else:
		distance_accum = trail_point_spacing # Ensure the first point is added
	# Add a new point if the accumulated distance exceeds the spacing
	if distance_accum >= trail_point_spacing:
		line2d.add_point(trail_pos)
		line2d2.add_point(trail_pos_2)
		distance_accum = 0.0
		# Remove the oldest point if we exceed the max number of points
		if line2d.get_point_count() > trail_max_points:
			line2d.remove_point(0)
		if line2d2.get_point_count() > trail_max_points:
			line2d2.remove_point(0)


func _on_hit_effect_timeout_timeout() -> void:
	$Sprite.modulate = Color(1,1,1)

func _on_tractor_body_entered(body: Node2D) -> void:
	print(body)
	if body is RigidBody2D:
		trapped_debris.append(body)


func _on_tractor_body_exited(body: Node2D) -> void:
	if body is RigidBody2D:
		trapped_debris.erase(body)
		
func _ready():
	$beam_sound.stream_paused = true
	if line2d == null:
		print("Error: line2d is not assigned. Please assign it in the editor.")
		return
	# Ensure the line2d node is empty at the start
	line2d.clear_points()
	
# Optionally, you can reset the trail
func reset_trail():
	if line2d != null:
		line2d.clear_points()
		distance_accum = 0.0
