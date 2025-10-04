extends CharacterBody2D

const TURNING_SPEED: float = 1.6
const FRICTION: float = 0.1 # TODO implement ?
const BOOST_FORCE: float = 100

var health: int = 3

signal health_changed(health: int)

func _physics_process(_delta):
	# after calling move_and_slide()
	for i in get_slide_collision_count():
		var c := get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			var impulse: Vector2 = Vector2(sin(rotation), cos(rotation))#-c.get_normal()/Vector2(sin(rotation), cos(rotation)) #* velocity.length()/10
			c.get_collider().apply_impulse(impulse, c.get_position())
			#if impulse.length() > 10 and $HitEffectTimeout.is_stopped():
			health -= 1
			health_changed.emit(health)
			$HitEffectTimeout.start()
			$Sprite.modulate = Color(2,2,2)

func _process(delta: float) -> void:
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


func _on_hit_effect_timeout_timeout() -> void:
	$Sprite.modulate = Color(1,1,1)
