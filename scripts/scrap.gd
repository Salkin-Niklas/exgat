extends RigidBody2D

const DELETE_DIST = 650

func  _process(_delta: float) -> void:
	if ($"../../Station".position - position).length() > DELETE_DIST and ($"../../Player".position - position).length() > DELETE_DIST:
		print("Deleted Scrap")
		queue_free()
