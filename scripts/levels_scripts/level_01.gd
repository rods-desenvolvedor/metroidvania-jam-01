extends BaseLevelClass

var player_scene = preload("res://scenes/player_scenes/player.tscn")

func _ready() -> void:
	super()
	player = get_tree().get_first_node_in_group("player")

func _on_skill_giver_component_new_skill():
	PlayerGlobalStatus.can_double_jump = true
	PlayerGlobalStatus.can_charge_attack = true
