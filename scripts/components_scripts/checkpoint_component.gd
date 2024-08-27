extends Node2D
class_name CheckpointComponentClass

@export var spawnpoint := false

var activade : bool = false
var player : CharacterBody2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func activate() -> void:
	GameManager.current_checkpoint = self
	activade = true
	$AnimatedSprite2D.play("save")


func _on_detect_player_component_body_entered(body: Node2D) -> void:
	if body == player && !activade:
		activate()


