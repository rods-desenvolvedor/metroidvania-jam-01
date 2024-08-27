extends CharacterBody2D

var player : CharacterBody2D
var player_area : Area2D
var speed : float
var base_speed : float = 30.0
var dir := -1
var player_on_attack_area : bool = false

@onready var health_component : HealthComponentClass = $HealthComponent
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox_component : HitboxComponentClass = $HitboxComponent

#var experience_scene = preload("res://scenes/components_scenes/experience_component.tscn")

enum States { MOVING, ATTACKING, CHASING}
var state = States.MOVING

var can_attack : bool = true

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	player_area = get_tree().get_first_node_in_group("player_area")
	hitbox_component.damage = 10.0
	speed = base_speed

func _process(delta: float) -> void:
	
	if !is_on_floor():
		velocity.y += 50.0
		
	handle_state_transitions()
	perform_state_transitions(delta)
	
	if dir == -1:
		animated_sprite.flip_h = true
	elif dir == 1:
		animated_sprite.flip_h = false
		
	position.x += dir * speed * delta
	
func _physics_process(_delta: float) -> void:
	move_and_slide()

func handle_state_transitions() -> void:
	pass

func perform_state_transitions(delta : float) ->void:
	match state:
		States.MOVING:
			speed = base_speed
			animated_sprite.play("walk")
			
		States.ATTACKING:
			speed = 0.0
			
			if can_attack:
				$AnimatedSprite2D.play("attack")
				$AnimationPlayer.play("attack")
				can_attack = false
				$AttackTimer.start()
			
		States.CHASING:
			if animated_sprite.is_playing():
				if animated_sprite.animation == "attack":
					return
			animated_sprite.play("walk")
				
			speed = base_speed
			
			if player.position > position:
				dir = 1
			elif player.position < position:
				dir = -1
				
			
	pass

func _on_health_component_died() -> void:
	#var xp = experience_scene.instantiate() as Node2D
	#xp.position = position
	#get_parent().add_child(xp)
	queue_free()

func _on_detect_player_component_area_entered(area: Area2D) -> void:
	if area == player_area:
		state = States.ATTACKING
		
func _on_detect_player_component_area_exited(area: Area2D) -> void:
	if area == player_area:
		state = States.CHASING

func _on_attack_timer_timeout() -> void:
	can_attack = true

func _on_chase_area_area_entered(area: Area2D) -> void:
	if area == player_area:
		state = States.CHASING

func _on_chase_area_area_exited(area: Area2D) -> void:
	if area == player_area:
		state = States.MOVING

func _on_health_component_get_hit():
	print(health_component.current_health)
