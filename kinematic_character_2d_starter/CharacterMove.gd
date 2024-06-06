extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var can_jump = true

func jump():
	velocity.y = -JUMP_VELOCITY
	can_jump = false

func jump_cut():
	if velocity.y < -100:
		velocity.y = -100

func on_coyote_time_timeout():
	can_jump = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if can_jump == false and is_on_floor() == true:
		can_jump = true
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump.
	if not is_on_floor() and can_jump and $coyote_time.is_stopped():
		$coyote_time.start()
	
	if Input.is_action_just_pressed("ui_up") and can_jump == true:
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_released("ui_up"):
		jump_cut()
		can_jump = false
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	apply_floor_snap()
	#hello world
