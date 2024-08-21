extends BaseLevelClass

var player_scene = preload("res://scenes/player_scenes/player.tscn")

func _ready() -> void:
	if LevelManager.new_game:
		player = player_scene.instantiate()
		add_child(player)
		player.position = $InitPos.position
		LevelManager.new_game = false
		
	super()
	player = get_tree().get_first_node_in_group("player")
	pass
