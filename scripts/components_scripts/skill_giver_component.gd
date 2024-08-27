extends Area2D


@export var skill_name : String
signal new_skill 
var player : PlayerClass
var player_area : Area2D
var player_on_skill_giver_area : bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	player_area = get_tree().get_first_node_in_group("player_area")
	
func _process(_delta) -> void:
	if player_on_skill_giver_area && Input.is_action_just_pressed("interact"):
		new_skill.emit()
		queue_free()

func _on_area_entered(area) -> void:
	if area == player_area:
		player_on_skill_giver_area = true

func _on_area_exited(area) -> void:
	if area == player_area:
		player_on_skill_giver_area = false
