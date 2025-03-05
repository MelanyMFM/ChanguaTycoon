extends CharacterBody3D

var esta_pidiendo_changua: bool = false
var changua_lista: bool = false
var tiempo_llegada: float = 0.0
var tiempo_espera_maximo: float = 30  
var jugador_en_area: bool = false  # Indica si el jugador está en el área de interacción

var posicion_inicial: Vector3
var posicion_final: Vector3
var velocidad: float = 0.3  
var estado: String = "caminando_a_espera"
var repeticiones: int = 0  
var max_repeticiones: int = 5  

# Referencias
@onready var animation_player: AnimationPlayer = $"character-female-a2/AnimationPlayer"
@onready var posicion_espera: Vector3 = $PosicionEspera.global_transform.origin
@onready var area_click: Area3D = $Area3D  # Ahora detectamos clics en el Area3D
@onready var plato: Sprite3D = $Area3D2/PlatoDeComida  # Plato dentro del Area3D
@onready var area_atencion: Area3D = get_parent().get_node("AreaAtencionCliente")
@onready var camera: Camera3D = get_parent().get_node("Camera3D") 

func _ready():
	posicion_inicial = global_transform.origin
	posicion_final = posicion_inicial  # Ahora el cliente regresará a su punto de origen
	tiempo_llegada = Time.get_ticks_msec() / 1000.0
	animation_player.play("idle")
	plato.visible = false
	# Conectar señales del área de atención
	area_atencion.connect("area_entered", Callable(self, "_on_area_atencion_cliente_area_entered"))
	area_atencion.connect("area_exited", Callable(self, "_on_area_atencion_cliente_area_exited"))
	# Conectar evento de clic en `Area3D`
	area_click.connect("input_event", Callable(self, "_on_cliente_clicked"))
	Logger.log("[Cliente] Cliente generado en posición inicial: " + str(posicion_inicial))

func _process(delta):
	match estado:
		"caminando_a_espera":
			mover_hacia(posicion_espera, delta)
			if global_transform.origin.distance_to(posicion_espera) < 0.1:
				estado = "esperando"
				pedir_changua()

		"esperando":
			animation_player.play("idle")

			# Verificar si el cliente esperó demasiado tiempo
			var tiempo_actual = Time.get_ticks_msec() / 1000.0
			if tiempo_actual - tiempo_llegada > tiempo_espera_maximo:
				print("[Cliente] El cliente esperó demasiado y se va insatisfecho.")
				Logger.log("El cliente esperó demasiado y se va insatisfecho.")
				estado = "caminando_a_final"

		"caminando_a_final":
			mover_hacia(posicion_final, delta)  # Ahora el cliente regresa a su posición inicial
			plato.visible = false
			if global_transform.origin.distance_to(posicion_final) < 0.1:
				repeticiones += 1  # Contar una repetición
				print("[Cliente] Cliente regresó a su posición inicial. Repetición: " + str(repeticiones))
				
				if repeticiones >= max_repeticiones:
					print("[Cliente] Cliente ha completado todas sus repeticiones y abandona el juego.")
					Global.clientes_restantes -= 1
					if Global.clientes_restantes <= 0:
						Logger.log("Nivel 1 acabado")
						get_tree().change_scene_to_file("res://lvl1end.tscn")
					queue_free()  # Eliminar cliente
				else:
					reiniciar_cliente()  # Reiniciar cliente para otra repetición

	# Hacer que el plato apunte siempre a la cámara
	if plato.visible and camera:
		plato.look_at(camera.global_transform.origin, Vector3.UP)

func mover_hacia(destino: Vector3, delta: float):
	var direccion = (destino - global_transform.origin).normalized()
	velocity = direccion * velocidad
	look_at(destino, Vector3.UP)
	
	if animation_player.current_animation != "walk":
		animation_player.play("walk")
	
	move_and_slide()

func pedir_changua():
	esta_pidiendo_changua = true
	plato.visible = true
	plato.look_at(camera.global_transform.origin, Vector3.UP)
	print("[Cliente] Cliente llegó a la zona de espera y está pidiendo changua.")
	Logger.log("Un cliente está pidiendo Changua")

func _on_area_atencion_cliente_area_entered(area: Area3D):
	if area.name == "AreaJugador":
		jugador_en_area = true
		print("[Cliente] El jugador ha entrado en la zona de atención del cliente.")

func _on_area_atencion_cliente_area_exited(area: Area3D):
	if area.name == "AreaJugador":
		jugador_en_area = false
		print("[Cliente] El jugador ha salido de la zona de atención del cliente.")

func _on_cliente_clicked(viewport, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if jugador_en_area:
			print("[Cliente] El jugador ha hecho clic en el cliente para entregarle la changua.")
			recibir_changua()
		else:
			print("[Cliente] El jugador intentó interactuar con el cliente, pero está fuera del área de atención.")

func recibir_changua():
	if Global.changuas_listas >= 1:
		entregar_changua()
		estado = "caminando_a_final"
	else:
		print("[Cliente] El jugador intentó entregar changua, pero no hay ninguna lista.")
		Logger.log("No puedes entregar, no hay changuas listas")

func entregar_changua():
	Global.changuas_listas -= 1
	var tiempo_actual = Time.get_ticks_msec() / 1000.0
	var tiempo_espera = tiempo_actual - tiempo_llegada

	if tiempo_espera <= tiempo_espera_maximo:
		var satisfaccion = 1.0 - (tiempo_espera / tiempo_espera_maximo)
		print("[Cliente] Changua entregada exitosamente.")
		Logger.log("Entregaste la changua exitosamente")
		Logger.log("Parece que al cliente le gustó (qué mal gusto)")
		print("[Cliente] Nivel de satisfacción: " + str(satisfaccion))
		Global.dinero += int(satisfaccion * 100) 
		print("[Cliente] El jugador ha ganado $" + str(satisfaccion * 100))
		Logger.log("Haz ganado $" + str(round(satisfaccion * 100)))
		print("[Cliente] Dinero actual: $" + str(Global.dinero))
	else:
		print("[Cliente] El cliente se fue insatisfecho porque esperó demasiado tiempo.")
		Logger.log("El cliente se fué insatisfecho porque esperó demasiado tiempo :(")

	plato.visible = false

func reiniciar_cliente():
	estado = "caminando_a_espera"
	esta_pidiendo_changua = false
	changua_lista = false
	tiempo_llegada = Time.get_ticks_msec() / 1000.0  # Reiniciar el tiempo de llegada
	print("[Cliente] Cliente reinicia su ciclo. Repetición: " + str(repeticiones))
