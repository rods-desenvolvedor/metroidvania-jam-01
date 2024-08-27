extends CharacterBody2D
class_name PlayerClass


var direction : float = 0.0
var speed : float = 50.0
var gravity_speed : float = 200.0
var jump_speed : float = -100.0
var mouse_pos : Vector2 = Vector2.ZERO
var can_move : bool = true
var last_dir : int = 1
var can_attack : bool = true

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox : HitboxComponentClass = $WeaponPivot/HitboxComponent

enum States { IDLE, MOVING, JUMPING , ATTACKING}
var state = States.IDLE

func _ready():
	hitbox.damage = 50.0
	$WeaponPivot/HitboxComponent/CollisionShape2D.disabled = true

func _process(delta: float) -> void:
	
	if can_move:
		direction = Input.get_axis("walk_left", "walk_right")
		
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0 , speed)

	velocity.x = direction * speed
	
	mouse_pos =  get_global_mouse_position()
	
	if not is_on_floor():
		velocity.y += gravity_speed * delta
		
	if velocity != Vector2.ZERO:
		last_dir = direction
	
	if last_dir > 0:
		animated_sprite.flip_h = false
		animated_sprite.offset.x = 6
		$WeaponPivot.scale.x = 1
	elif last_dir < 0:
		animated_sprite.flip_h = true
		animated_sprite.offset.x = -6
		$WeaponPivot.scale.x = -1
		
	#use_skills()
	#update_animation()

func _physics_process(delta: float) -> void:
	handle_state_transitions()
	perform_state_actions(delta)
	move_and_slide()
	
func handle_state_transitions() -> void:
		match state:
			States.IDLE:
				if Input.is_action_just_pressed("walk_left") or Input.is_action_just_pressed("walk_right"):
					state = States.MOVING
				elif Input.is_action_just_pressed("jump"):
					state = States.JUMPING
				elif Input.is_action_just_pressed("attack") && can_attack:
					state = States.ATTACKING
					
			States.MOVING:
				if not Input.is_action_pressed("walk_right") and not Input.is_action_pressed("walk_left"):
					state = States.IDLE
				elif Input.is_action_just_pressed("jump"):
					state = States.JUMPING
				elif Input.is_action_just_pressed("attack") && can_attack:
					state = States.ATTACKING
					
			States.JUMPING:
				if is_on_floor():
					state = States.IDLE
				elif !is_on_floor() && Input.is_action_just_pressed("attack") && can_attack:
					state = States.ATTACKING
			States.ATTACKING:
				if animated_sprite.animation == "attack":
					await animated_sprite.animation_finished
					state = States.MOVING if is_on_floor() else States.JUMPING

func perform_state_actions(delta : float) -> void:
	match state:
		States.IDLE:
			velocity.x = 0
			animated_sprite.play("idle")

		States.MOVING:
			animated_sprite.play("walk")

		States.JUMPING:
			animated_sprite.play("jump")
			if is_on_floor():
				PlayerGlobalStatus.jump_count = 0
			if Input.is_action_just_pressed("jump") && PlayerGlobalStatus.jump_count < PlayerGlobalStatus.max_jumps:
				velocity.y = jump_speed
				PlayerGlobalStatus.jump_count += 1

		States.ATTACKING:
			#velocity.x = 0 
			if can_attack:
				can_attack = false
				animated_sprite.play("attack")
				$AnimationPlayer.play("attack")
				$Timers/AttackTimer.start()
	
		
func update_animation() -> void:
	if is_on_floor():
		if direction == 0.0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("walk")
	else:
		animated_sprite.play("jump")
		
	if velocity != Vector2.ZERO:
		last_dir = direction
		
	if last_dir > 0:
		animated_sprite.flip_h = false
		animated_sprite.offset.x = 6
		$WeaponPivot.scale.x = 1
	elif last_dir < 0:
		animated_sprite.flip_h = true
		animated_sprite.offset.x = -6
		$WeaponPivot.scale.x = -1
	
	


func use_skills() -> void:
	if is_on_floor():
		PlayerGlobalStatus.jump_count = 0
	if Input.is_action_just_pressed("jump") && PlayerGlobalStatus.jump_count < PlayerGlobalStatus.max_jumps:
		velocity.y = jump_speed
		PlayerGlobalStatus.jump_count += 1
	pass


func _on_health_component_get_hit():
	print("vida do jogador : " + str($HealthComponent.current_health))


func _on_health_component_died():
	GameManager.respawn_player()


func _on_attack_timer_timeout():
	can_attack = true
