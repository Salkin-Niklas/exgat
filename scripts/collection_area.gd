extends Node2D

var goal_n1: Vector2
var goal_n2: Vector2
var goal_n3: Vector2
var goal_n4: Vector2

var is_translating: int = 0

const BEACON_SPEED = 30

func reset():
	#$Net.n1  = to_global(position)
	#$Net.n2  = to_global(position)
	#$Net.n3  = to_global(position)
	#$Net.n4  = to_global(position)
	position = Vector2(randf_range(200,500)*(1-(randi()%2)*2), randf_range(200,500)*(1-(randi()%2)*2))
	goal_n1 = Vector2(-15,-15) + Vector2(randf_range(-3,3), randf_range(-3,3))
	goal_n2 = Vector2(15,-15) + Vector2(randf_range(-3,3), randf_range(-3,3))
	goal_n3 = Vector2(15,15) + Vector2(randf_range(-3,3), randf_range(-3,3))
	goal_n4 = Vector2(-15,15) + Vector2(randf_range(-3,3), randf_range(-3,3))
	#$Net.n1  = to_local($Net.n1)
	#$Net.n2  = to_local($Net.n2)
	#$Net.n3  = to_local($Net.n3)
	#$Net.n4  = to_local($Net.n4)
	
	$Net.n1  = Vector2(0,0)
	$Net.n2  = Vector2(0,0)
	$Net.n3  = Vector2(0,0)
	$Net.n4  = Vector2(0,0)
	
	h = 0
	is_translating = 0

func _ready() -> void:
	randomize()
	reset()

func _enter_tree()->void:
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
			$NetTimer.start()
			$Label.position = Vector2(-50,-50)
			$Label.show()
		$Net.update(0)
	elif is_translating == 6:
		$Label.hide()
		goal_n1 = Vector2(0,0)
		goal_n2 = Vector2(0,0)
		goal_n3 = Vector2(0,0)
		goal_n4 = Vector2(0,0)
		if not round($Net.n1) == round(goal_n1):
			$Net.n1 = $Net.n1-(($Net.n1-goal_n1).normalized() * delta * BEACON_SPEED).limit_length(min(($Net.n1-goal_n1).length(), BEACON_SPEED))
		if not round($Net.n2) == round(goal_n2):
			$Net.n2 = $Net.n2-(($Net.n2-goal_n2).normalized() * delta * BEACON_SPEED).limit_length(min(($Net.n2-goal_n2).length(), BEACON_SPEED))
		if not round($Net.n3) == round(goal_n3):
			$Net.n3 = $Net.n3-(($Net.n3-goal_n3).normalized() * delta * BEACON_SPEED).limit_length(min(($Net.n3-goal_n3).length(), BEACON_SPEED))
		if not round($Net.n4) == round(goal_n4):
			$Net.n4 = $Net.n4-(($Net.n4-goal_n4).normalized() * delta * BEACON_SPEED).limit_length(min(($Net.n4-goal_n4).length(), BEACON_SPEED))
		if round($Net.n1) == round(goal_n1) and round($Net.n2) == round(goal_n2) and round($Net.n3) == round(goal_n3) and round($Net.n4) == round(goal_n4):
			$Net.update(0)
			reset()
		else:
			$Net.update(100)
	else:
		h += delta
		if (h < 4):
			$Net.update(int(h*20))
		$Label.text = str(int(round($NetTimer.time_left)))

func _on_beacon_timer_timeout() -> void:
	if is_translating >= 0 and is_translating < 3:
		is_translating += 1


func _on_net_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		print("Scrap entered Net")
		body.linear_damp_mode = RigidBody2D.DAMP_MODE_COMBINE
		body.linear_damp = 0.9
		body.trapped_in = self


func _on_net_timer_timeout() -> void:
	is_translating = 6
	get_tree().call_group("Scrap", "toward", self)


func _on_net_body_exited(body: Node2D) -> void:
	if body is RigidBody2D:
		print("Scrap exited Net")
		body.linear_damp = 0
		body.trapped_in = null


func _on_gameover_reset() -> void:
	reset()
