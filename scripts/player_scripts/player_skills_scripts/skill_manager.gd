class_name SkillManager extends Node

@onready var player_area : Area2D = $"../PlayerArea"

func _ready() -> void:
	player_area.area_entered.connect(_on_player_area_entered)



func _on_player_area_entered(area : Area2D) -> void:
	pass
