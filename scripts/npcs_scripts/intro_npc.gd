extends CharacterBody2D

var player : CharacterBody2D
var player_area : Area2D

var player_on_npc_area : bool = false


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	player_area = get_tree().get_first_node_in_group("player_area")
	
func _process(_delta: float) -> void:
	pass
	if Dialogic.current_timeline != null:
		return
	if Input.is_action_just_pressed("interact") && player_on_npc_area:
		Dialogic.start("intro")


func _on_npc_area_component_area_entered(area):
	if area == player_area:
		player_on_npc_area = true


func _on_npc_area_component_area_exited(area):
	if area == player_area:
		player_on_npc_area = false
