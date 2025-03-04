extends CharacterBody3D

const SPEED = .5  # Ajusta la velocidad según sea necesario
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var target_position: Vector3 = Vector3.ZERO
var is_moving: bool = false

# Referencia al AnimationPlayer
@onready var animation_player: AnimationPlayer = $"character-male-a2/AnimationPlayer"

func _ready():
	# Reproducir la animación de idle al inicio
	animation_player.play("idle")

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Obtener la posición del clic en la pantalla
			var ray_origin = $"../Camera3D".project_ray_origin(event.position)
			var ray_direction = $"../Camera3D".project_ray_normal(event.position)
			
			# Calcular la intersección con el plano del suelo (y = 0)
			var ground_plane = Plane(Vector3.UP, 0)
			var intersection = ground_plane.intersects_ray(ray_origin, ray_direction)
			
			# Establecer la posición objetivo
			target_position = intersection
			is_moving = true

func _physics_process(delta):
	if is_moving:
		_movement(delta)
	else:
		# Si no se está moviendo, reproducir la animación de idle
		if animation_player.current_animation != "idle":
			animation_player.play("idle")
	
	_gravity(delta)

func _movement(delta):
	var direction = (target_position - global_transform.origin).normalized()
	
	# Mover al personaje hacia la posición objetivo
	if global_transform.origin.distance_to(target_position) > 0.1:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		# Rotar el personaje hacia la dirección de movimiento
		look_at(target_position, Vector3.UP)
		
		# Reproducir la animación de caminar
		if animation_player.current_animation != "walk":  # Asegúrate de que "walk" sea el nombre correcto de la animación
			animation_player.play("walk")
	else:
		# Detener el movimiento cuando llegue cerca del objetivo
		velocity.x = 0
		velocity.z = 0
		is_moving = false
	
	move_and_slide()

func _gravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
