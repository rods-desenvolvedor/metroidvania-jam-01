extends Node

var bullet_count : int = 1
var gun_max_range : float = 75.0

var can_double_jump : bool = false
var jump_count : int = 0
var max_jumps : int = 1

var can_charge_attack : bool = false

func _process(_delta):
	if can_double_jump:
		max_jumps = 2
