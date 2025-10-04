extends CharacterBody2D

const TURNING_SPEED: float = 1.6
const FRICTION: float = 0.1 # TODO implement ?
const BOOST_FORCE: float = 100

var health: float = 100.0

var trapped_debris: Array[RigidBody2D] = []

signal health_changed(health: int)

func _physics_process(delta: float) -> void:
	var base: String = "idle"
	if Input.is_action_pressed("Boost"):
		velocity.x += BOOST_FORCE*delta * sin(rotation)
		velocity.y -= BOOST_FORCE*delta * cos(rotation)
		base = "boost"
	if Input.is_action_pressed("TurnL"):
		rotation -= TURNING_SPEED*delta
		base += "R"
	elif Input.is_action_pressed("TurnR"):
		rotation += TURNING_SPEED*delta
		base += "L"
		
	move_and_slide()
	if randi() % 2 == 0:
		$Sprite.animation = base
	else: $Sprite.animation = "idle"
	
	## after calling move_and_slide()
	#for i in get_slide_collision_count():
		#var c := get_slide_collision(i)
		#if c.get_collider() is RigidBody2D:
			##var impulse: Vector2 = Vector2(sin(rotation), -cos(rotation))#-c.get_normal()/Vector2(sin(rotation), cos(rotation)) #* velocity.length()/10
			##impulse 
			##c.get_collider().apply_impulse(impulse, c.get_position())
			###if impulse.length() > 10 and $HitEffectTimeout.is_stopped():
			##$HitEffectTimeout.start()
			##$Sprite.modulate = Color(2,2,2)
			#
			#var damage: float = abs(c.get_collider().linear_velocity.dot(c.get_normal())) + abs(self.velocity.dot(c.get_normal()))
			#if damage < 5.0:
				#damage = 0.0
			#print(damage)
			#health-= damage
			#health_changed.emit(health)

	if Input.is_key_pressed(KEY_SPACE):
		$Tractor.monitoring = true
	else:
		$Tractor.monitoring = false
	
	if $Tractor.monitoring == true:
		for d in trapped_debris:
			var force: Vector2 = Vector2(0,0)
			force -= (d.global_position-(global_position+Vector2(0,-85).rotated(rotation)))*10
			force -= (d.linear_velocity-velocity)*100
			print(d.linear_velocity)
			d.apply_central_force(force)
		print(velocity)



func _on_hit_effect_timeout_timeout() -> void:
	$Sprite.modulate = Color(1,1,1)


func _on_tractor_body_entered(body: Node2D) -> void:
	print(body)
	if body is RigidBody2D:
		trapped_debris.append(body)


func _on_tractor_body_exited(body: Node2D) -> void:
	if body is RigidBody2D:
		trapped_debris.erase(body)
