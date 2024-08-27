extends RayCast2D



func _process(delta: float) -> void:
	if !is_colliding() && owner.is_on_floor():
		owner.dir = -1
