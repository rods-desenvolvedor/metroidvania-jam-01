extends BaseLevelClass


func _ready() -> void:
	super()

func _on_skill_giver_component_new_skill():
	PlayerGlobalStatus.can_double_jump = true
	PlayerGlobalStatus.can_charge_attack = true
