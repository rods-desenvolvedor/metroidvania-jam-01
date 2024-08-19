extends Node
class_name HealthComponentClass

signal died
signal get_hit

@export var max_health : float = 100.0
var current_health : float
var player : CharacterBody2D

func _ready() -> void:
	current_health = max_health
	player = get_tree().get_first_node_in_group("player")
	
func damage(_damage : float) -> void:
	current_health = max(current_health - _damage, 0)
	get_hit.emit()
	Callable(checK_death).call_deferred()

func checK_death() -> void:
	if current_health == 0.0:
		died.emit()
	
