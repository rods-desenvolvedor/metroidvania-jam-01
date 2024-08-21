extends Area2D

@export var connected_scene : String
var player_area : Area2D


func _ready() -> void:
	player_area = get_tree().get_first_node_in_group("player_area")


func _on_area_entered(area: Area2D) -> void:
	player_area = get_tree().get_first_node_in_group("player_area")
	if area == player_area:
		LevelManager.change_scene(owner, connected_scene)
		print("player detectado")
