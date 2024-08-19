extends Area2D
class_name HurtboxComponentClass

@export var health_component : Node



func _on_area_entered(area: Area2D) -> void:
	var hitbox_component = area as HitboxComponentClass
	health_component.damage(hitbox_component.damage)
	pass
