extends Node2D

@export var bullet : PackedScene
@export_range(0, 360) var arc : float = 0.0
@export_range(0, 20) var fire_rate : float = 1.0

var can_shoot : bool = true
var can_charged_shoot : bool = true

@onready var bullet_initial_pos : Marker2D = $"../GunSprite/BulletInitialPos"
@onready var charging = $"../../ProgressBar"

func _process(delta: float) -> void:
	charging.value += delta
	if !PlayerGlobalStatus.can_charge_attack:
		if Input.is_action_just_pressed("shoot"):
			shoot()
	
	
func _input(event):
	if !PlayerGlobalStatus.can_charge_attack:
		pass
	elif PlayerGlobalStatus.can_charge_attack:
		if event.is_action_pressed("charged_shoot"):
			#owner.can_move = false
			print("charging")
			charging.value = 1.0
			if can_charged_shoot:
				charging.show()
		elif event.is_action_released("charged_shoot"):
			#owner.can_move = true
			print("charged shoot!!")
			if can_charged_shoot:
				charged_shoot()
			charging.hide()
		elif event.is_action("shoot"):
			shoot()
	pass
	
func shoot() -> void:
	if can_shoot:
		can_shoot = false
	
		for i in PlayerGlobalStatus.bullet_count:
			var new_bullet = bullet.instantiate() as Node2D
			new_bullet.position = bullet_initial_pos.global_position
			new_bullet.get_node("HitboxComponent").damage = 50.0
			print(new_bullet.get_node("HitboxComponent").damage)
			if PlayerGlobalStatus.bullet_count == 1:
				new_bullet.rotation = global_rotation
			else:
				var arc_rad = deg_to_rad(arc)
				var increment = arc_rad / (PlayerGlobalStatus.bullet_count - 1)
				new_bullet.global_rotation = (global_rotation + increment * i - arc_rad / 2)
			
			get_tree().root.call_deferred("add_child", new_bullet)
			
		$"../../Timers/ShootTimer".start()


func charged_shoot():
	if can_charged_shoot:
		can_charged_shoot = false
		for i in PlayerGlobalStatus.bullet_count:
			var new_bullet = bullet.instantiate() as Node2D
			new_bullet.position = bullet_initial_pos.global_position
			new_bullet.get_node("HitboxComponent").damage = 50.0 * charging.value
			print(new_bullet.get_node("HitboxComponent").damage)
			
			if PlayerGlobalStatus.bullet_count == 1:
				new_bullet.rotation = global_rotation
			else:
				var arc_rad = deg_to_rad(arc)
				var increment = arc_rad / (PlayerGlobalStatus.bullet_count - 1)
				new_bullet.global_rotation = (global_rotation + increment * i - arc_rad / 2)
			
			get_tree().root.call_deferred("add_child", new_bullet)
		$"../../Timers/ChargedShootTimer".start()
	pass
	
func _on_shoot_timer_timeout() -> void:
	can_shoot = true


func _on_charged_shoot_timer_timeout():
	can_charged_shoot = true
