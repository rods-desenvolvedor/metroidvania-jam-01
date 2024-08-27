extends CharacterBody2D

var speed : float = 3.5
var direction : Vector2 = Vector2.RIGHT
var player : CharacterBody2D
var player_initial_pos : Vector2

@onready var hitbox_component : HitboxComponentClass = $HitboxComponent


func _ready():
	player = get_tree().get_first_node_in_group("player")
	player_initial_pos = player.position
	direction = Vector2.RIGHT.rotated(global_rotation)
	#hitbox_component.body_entered.connect(_on_body_entered)
	#hitbox_component.damage = 50.0
	pass
	
func _process(_delta):
	if !player:
		return
	
	if position.distance_to(player_initial_pos) > PlayerGlobalStatus.gun_max_range:
		#velocity = Vector2.ZERO
		if !$AnimatedSprite2D.is_playing():
			$AnimatedSprite2D.play("burst")
	else:
		velocity = direction * speed
		var _collision = move_and_collide(velocity)


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "burst":
		queue_free()

func _on_hitbox_component_area_entered(_area: Area2D) -> void:
	if !$AnimatedSprite2D.is_playing():
			$AnimatedSprite2D.play("burst")

func _on_hitbox_component_body_entered(_body):
	if !$AnimatedSprite2D.is_playing():
			$AnimatedSprite2D.play("burst")
