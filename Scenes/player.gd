extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -500.0

var idle = preload("res://Sprites/lil_guy_idle.png")
var jump = preload("res://Sprites/lil_guy_jump.png")
var walk1 = preload("res://Sprites/lil_guy_walk1.png")
var walk2 = preload("res://Sprites/lil_guy_walk2.png")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		$Sprite2D.texture = jump
	elif velocity.x != 0:
		$Sprite2D.texture = walk1
	else:
		$Sprite2D.texture = idle
		
		

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		$Sprite2D.scale.x = direction * 4
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
