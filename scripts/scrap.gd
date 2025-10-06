extends RigidBody2D

const DELETE_DIST = 650
const BEACON_SPEED = 80
var trapped_in: Node2D = null
var target: Vector2 = Vector2(0,0)
var origin: Vector2 = Vector2(0,0)
var h: float = 0

func _ready() -> void:
	add_to_group("Scrap")

func  _process(delta: float) -> void:
	if ($"../../Station".position - position).length() > DELETE_DIST and ($"../../Player".position - position).length() > DELETE_DIST:
		print("Deleted Scrap")
		queue_free()
	if target != Vector2(0,0):
		h += delta
		if h <= 1:
			position = lerp(origin, target, h)
		else:
			$"..".score(1)
			queue_free()

func toward(pos: Node2D)->void:
	if pos == trapped_in:
		set_deferred("disabled", true)
		print("Target ", pos.position, " set")
		target = pos.position
		origin = position
