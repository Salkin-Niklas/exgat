extends Node2D

var goal_n1: Vector2
var goal_n2: Vector2
var goal_n3: Vector2
var goal_n4: Vector2

var is_translating: int = 0

const BEACON_SPEED = 30

func _ready() -> void:
	randomize()
	goal_n1 = Vector2(-15,-15) + Vector2(randf_range(-3,3), randf_range(-3,3))
	goal_n2 = Vector2(15,-15) + Vector2(randf_range(-3,3), randf_range(-3,3))
	goal_n3 = Vector2(15,15) + Vector2(randf_range(-3,3), randf_range(-3,3))
	goal_n4 = Vector2(-15,15) + Vector2(randf_range(-3,3), randf_range(-3,3))
	
	$Net.n1  = Vector2(0,0)
	$Net.n2  = Vector2(0,0)
	$Net.n3  = Vector2(0,0)
	$Net.n4  = Vector2(0,0)

var h: float = 0

func  _process(delta: float) -> void:
	if is_translating < 4:
		if is_translating >= 0 and not round($Net.n1) == round(goal_n1):
			$Net.n1 = $Net.n1-(($Net.n1-goal_n1).normalized() * delta * BEACON_SPEED).limit_length(min(($Net.n1-goal_n1).length(), BEACON_SPEED))
		if is_translating >= 1 and not round($Net.n2) == round(goal_n2):
			$Net.n2 = $Net.n2-(($Net.n2-goal_n2).normalized() * delta * BEACON_SPEED).limit_length(min(($Net.n2-goal_n2).length(), BEACON_SPEED))
		if is_translating >= 2 and not round($Net.n3) == round(goal_n3):
			$Net.n3 = $Net.n3-(($Net.n3-goal_n3).normalized() * delta * BEACON_SPEED).limit_length(min(($Net.n3-goal_n3).length(), BEACON_SPEED))
		if is_translating >= 3 and not round($Net.n4) == round(goal_n4):
			$Net.n4 = $Net.n4-(($Net.n4-goal_n4).normalized() * delta * BEACON_SPEED).limit_length(min(($Net.n4-goal_n4).length(), BEACON_SPEED))
		if round($Net.n1) == round(goal_n1) and round($Net.n2) == round(goal_n2) and round($Net.n3) == round(goal_n3) and round($Net.n4) == round(goal_n4):
			is_translating += 1
		$Net.update(0)
	else:
		h += delta
		$Net.update(int(h*20))

func _on_beacon_timer_timeout() -> void:
	if is_translating >= 0 and is_translating < 3:
		is_translating += 1


func _on_net_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		print("Scrap entered Net")
		body.linear_damp_mode = RigidBody2D.DAMP_MODE_COMBINE
		body.linear_damp = 0.4
