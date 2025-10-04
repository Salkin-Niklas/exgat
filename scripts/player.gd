extends AnimatedSprite2D

var force: Vector2 = Vector2()
const TURNING_SPEED: float = 1.6
const BOOST_FORCE: float = 100


func _process(delta: float) -> void:
	var base: String = "idle"
	if Input.is_action_pressed("Boost"):
		force.x += BOOST_FORCE*delta * sin(rotation)
		force.y -= BOOST_FORCE*delta * cos(rotation)
		base = "boost"
	if Input.is_action_pressed("TurnL"):
		rotation -= TURNING_SPEED*delta
		base += "R"
	elif Input.is_action_pressed("TurnR"):
		rotation += TURNING_SPEED*delta
		base += "L"
		
	position += force*delta
	if randi() % 2 == 0:
		animation = base
	else: animation = "idle"
