extends Node2D

@export var bullet : PackedScene
@export_range(0, 360) var arc : float = 0.0
@export_range(0, 20) var fire_rate : float = 1.0

var can_shoot : bool = true

@onready var bullet_initial_pos : Marker2D = $"../GunSprite/BulletInitialPos"

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot()
		pass
	
func shoot() -> void:
	if can_shoot:
		can_shoot = false
	
		for i in PlayerGlobalStatus.bullet_count:
			var new_bullet = bullet.instantiate() as Node2D
			new_bullet.position = bullet_initial_pos.global_position
			
			if PlayerGlobalStatus.bullet_count == 1:
				new_bullet.rotation = global_rotation
			else:
				var arc_rad = deg_to_rad(arc)
				var increment = arc_rad / (PlayerGlobalStatus.bullet_count - 1)
				new_bullet.global_rotation = (global_rotation + increment * i - arc_rad / 2)
			
			get_tree().root.call_deferred("add_child", new_bullet)
			
		$"../../Timers/ShootTimer".start()

func _on_shoot_timer_timeout() -> void:
	can_shoot = true
