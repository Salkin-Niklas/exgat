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
		if is_translating > 0:
			$Net.n1 = goal_n1#($Net.n1-goal_n1).normalized() * delta
		if is_translating > 1:
			$Net.n2 = goal_n2#($Net.n2-goal_n2).normalized() * delta
		if is_translating > 2:
			$Net.n3 = goal_n3#($Net.n3-goal_n3).normalized() * delta
		if is_translating > 3:
			$Net.n4 = goal_n4#($Net.n4-goal_n4).normalized() * delta
		if $Net.n1 == goal_n1 and $Net.n2 == goal_n2 and $Net.n3 == goal_n3 and $Net.n4 == goal_n4:
			is_translating += 1
		$Net.update(0)
	else:
		h += delta
		$Net.update(int(h*20))

func _on_beacon_timer_timeout() -> void:
	if is_translating >= 0 and is_translating < 5:
		is_translating += 1
