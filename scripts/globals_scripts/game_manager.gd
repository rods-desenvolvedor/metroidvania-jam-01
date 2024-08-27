extends Node

var current_checkpoint : CheckpointComponentClass

var player : PlayerClass


func respawn_player() -> void:
	player = get_tree().get_first_node_in_group("player")
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position

