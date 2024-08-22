extends Area2D


@export var skill_scene : PackedScene
var player : PlayerClass
var player_area : Area2D
var player_on_skill_giver_area : bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	player_area = get_tree().get_first_node_in_group("player")
	
func _process(delta) -> void:
	if player_on_skill_giver_area && Input.is_action_just_pressed("interact"):
		var skill = skill_scene.instantiate()
		player.get_node("SkillManager").add_child(skill)

func _on_area_entered(area) -> void:
	if area == player_area:
		player_on_skill_giver_area = true

func _on_area_exited(area) -> void:
	if area == player_area:
		player_on_skill_giver_area = false
