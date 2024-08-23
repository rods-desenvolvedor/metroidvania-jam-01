extends CharacterBody2D
class_name PlayerClass


var direction : float = 0.0
var speed : float = 50.0
var gravity_speed : float = 200.0
var jump_speed : float = -100.0
var mouse_pos : Vector2 = Vector2.ZERO
var can_move : bool = true

@onready var gun_pivot : Marker2D = $GunPivot
@onready var gun_sprite : Sprite2D = $GunPivot/GunSprite
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D



func _process(delta: float) -> void:
	
	if can_move:
		direction = Input.get_axis("walk_left", "walk_right")
	
	mouse_pos =  get_global_mouse_position()
	
	if not is_on_floor():
		velocity.y += gravity_speed * delta
		
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0 , speed)
		
	use_skills()
	update_animation()
	move_gun()
	
func move_gun() -> void:
	gun_pivot.rotation_degrees = rad_to_deg(position.angle_to_point(mouse_pos))
	
	if gun_pivot.rotation_degrees > -90 && gun_pivot.rotation_degrees < 90:
		gun_sprite.flip_v = false
	else:
		gun_sprite.flip_v = true
	
	if gun_pivot.rotation_degrees > -90 && gun_pivot.rotation_degrees < 90:
		animated_sprite.flip_h = false
		animated_sprite.offset.x = 6
	else:
		animated_sprite.flip_h = true
		animated_sprite.offset.x = -6
		
func update_animation() -> void:
	if is_on_floor():
		if direction == 0.0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("walk")
	else:
		animated_sprite.play("jump")
	
func _physics_process(_delta: float) -> void:
	move_and_slide()

func use_skills() -> void:
	if is_on_floor():
		PlayerGlobalStatus.jump_count = 0
	if Input.is_action_just_pressed("jump") && PlayerGlobalStatus.jump_count < PlayerGlobalStatus.max_jumps:
		velocity.y = jump_speed
		PlayerGlobalStatus.jump_count += 1
	pass
