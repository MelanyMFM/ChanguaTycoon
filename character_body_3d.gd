extends CharacterBody3D


const SPEED = 1
const JUMP_VELOCITY = 2

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _movement():
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()


func _gravity(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta


func _jump():
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func _physics_process(delta):
	_movement()
	_gravity(delta)
	_jump()
