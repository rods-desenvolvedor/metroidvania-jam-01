class_name LevelManagerClass extends Node


var player : PlayerClass
var last_scene_name : String
var new_game : bool = true

var scene_dir_path : String = "res://scenes/levels_scenes/"

func change_scene(old_scene, new_scene_name : String) -> void:
	last_scene_name = old_scene.name
	player = old_scene.player
	player.get_parent().remove_child(player)
	var full_path = scene_dir_path + new_scene_name + ".tscn"
	old_scene.get_tree().call_deferred("change_scene_to_file", full_path)
