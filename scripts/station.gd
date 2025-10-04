extends Area2D

var health: float = 5

signal gameover()

func _process(_delta: float) -> void:
	if health<=0:
		emit_signal("gameover")
		$Sprite2D.texture = preload("res://assets/station/station.png")
		$Sprite2D.hide()

func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, local_shape_index: int) -> void:
	#var other_shape_owner = body.shape_find_owner(body_shape_index)
	#var other_shape_node = body.shape_owner_get_owner(other_shape_owner)
	#other_shape_node.get_parent().destroy()
	if body is not RigidBody2D:
		return
	body.queue_free()

	var local_shape_owner = shape_find_owner(local_shape_index)
	var local_shape_node = shape_owner_get_owner(local_shape_owner)
	local_shape_node.get_child(0).texture = preload("res://assets/station/panel.png")
	local_shape_node.get_child(0).hide()
	local_shape_node.set_deferred("disabled", true)
	health -= 1
	print("station damaged, ", health)
