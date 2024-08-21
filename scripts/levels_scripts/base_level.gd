class_name BaseLevelClass extends Node

var player : PlayerClass
@onready var entrance_markers : Node2D = $EntranceMarkers

func _ready() -> void:
	if LevelManager.player:
		if player:
			player.queue_free()
		
		player = LevelManager.player
		add_child(player)
		player = get_tree().get_first_node_in_group("player")
	if player:
		position_player()
		pass
		
func position_player() -> void:
	var last_scene = LevelManager.last_scene_name
	if last_scene.is_empty():
		last_scene = "1"
	for entrance in entrance_markers.get_children():
		if entrance is Marker2D and entrance.name == "1" or entrance.name == last_scene:
			print(last_scene)
			player.global_position = entrance.global_position
