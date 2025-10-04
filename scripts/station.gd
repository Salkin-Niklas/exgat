extends Area2D

var health: float = 0

signal health_changed(val: float)
signal gameover()

func _process(_delta: float) -> void:
	if health<=0:
		emit_signal("gameover")
		$Sprite2D.texture = preload("res://assets/station/station.png")
		$Sprite2D.hide()

func _on_area_shape_entered(_area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	var other_shape_owner = area.shape_find_owner(area_shape_index)
	var other_shape_node = area.shape_owner_get_owner(other_shape_owner)
	other_shape_node.get_parent().destroy()

	var local_shape_owner = shape_find_owner(local_shape_index)
	var local_shape_node = shape_owner_get_owner(local_shape_owner)
	local_shape_node.get_child(0).texture = preload("res://assets/station/panel.png")
	local_shape_node.get_child(0).texture.hide()
	local_shape_node.disabled = true
	health -= 1
	emit_signal("health_changed", health)
	print("station damaged, ", health)
