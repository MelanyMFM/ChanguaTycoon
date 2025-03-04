extends CharacterBody3D

var esta_pidiendo_changua: bool = false
var changua_lista: bool = false
var tiempo_llegada: float = 0.0
var tiempo_espera_maximo: float = 30  # Tiempo máximo que el cliente esperará

var posicion_inicial: Vector3
var posicion_espera: Vector3
var posicion_final: Vector3
var velocidad: float = 0.4  # Velocidad de movimiento del cliente
var estado: String = "caminando_a_espera"  # Estado actual del cliente
var repeticiones: int = 0  # Contador de repeticiones
var max_repeticiones: int = 5  # Número máximo de repeticiones

func _ready():
	posicion_inicial = global_transform.origin  # Guardar la posición inicial
	posicion_espera = Vector3(-0.718, 0.053, -0.973)  # Define la posición de espera (ajusta los valores)
	posicion_final = posicion_inicial  # El cliente volverá a su posición inicial
	tiempo_llegada = Time.get_ticks_msec() / 1000.0  # Registrar el tiempo de llegada
	Logger.log("Dinero actual: $" + str(Global.dinero))

func _process(delta):
	match estado:
		"caminando_a_espera":
			mover_hacia(posicion_espera, delta)
			if global_transform.origin.distance_to(posicion_espera) < 0.1:
				estado = "esperando"
				#print("El cliente llegó a la posición de espera.")

		"esperando":
			if esta_pidiendo_changua:
				var tiempo_actual = Time.get_ticks_msec() / 1000.0
				if tiempo_actual - tiempo_llegada > tiempo_espera_maximo:
					Logger.log("El cliente 2 se fue insatisfecho.")
					estado = "caminando_a_final"

		"caminando_a_final":
			mover_hacia(posicion_final, delta)
			if global_transform.origin.distance_to(posicion_final) < 0.1:
				#Logger.log("El cliente se fue.")
				repeticiones += 1  # Incrementar el contador de repeticiones
				if repeticiones >= max_repeticiones:
					#print("El cliente completó sus 5 repeticiones y se va.")
					Global.clientes_restantes -= 1
					if Global.clientes_restantes <= 0:
						Logger.log("Nivel 1 acabado")
		# Mostrar un mensaje o cambiar a una escena de fin de nivel
						get_tree().change_scene_to_file("res://lvl1end.tscn")
					queue_free()  # Eliminar al cliente de la escena
				else:
					# Esperar entre 1 a 15 segundos
					reiniciar_cliente()  # Reiniciar el cliente para otra repetición

func mover_hacia(destino: Vector3, delta: float):
	var direccion = (destino - global_transform.origin).normalized()
	velocity = direccion * velocidad
	move_and_slide()

func reiniciar_cliente():
	estado = "caminando_a_espera"
	esta_pidiendo_changua = false
	changua_lista = false
	tiempo_llegada = Time.get_ticks_msec() / 1000.0  # Reiniciar el tiempo de llegada
	#print("El cliente comienza un nuevo ciclo. Repetición:", repeticiones + 1)

func _on_area_3d_body_entered(body):
	if body.name == "CharacterBody3D":  # Cambia "CharacterBody3D" por "Jugador"
		if estado == "esperando" and not esta_pidiendo_changua:
			esta_pidiendo_changua = true
			Logger.log("El cliente 2 está pidiendo changua.")
		elif estado == "esperando" and esta_pidiendo_changua:
			recibir_changua()

func _on_estufa_changua_lista():
	changua_lista = true
	Logger.log("La changua está lista para entregar.")

func recibir_changua():
	if Global.changuas_listas >= 1:  # Solo entregar si la changua está lista
		entregar_changua()
		estado = "caminando_a_final"  # Cambiar estado para que se vaya
	else:
		Logger.log("La changua no está lista todavía.")

func entregar_changua():
	Global.changuas_listas -= 1
	var tiempo_actual = Time.get_ticks_msec() / 1000.0
	var tiempo_espera = tiempo_actual - tiempo_llegada

	if tiempo_espera <= tiempo_espera_maximo:
		var satisfaccion = 1.0 - (tiempo_espera / tiempo_espera_maximo)
		Logger.log("Changua entregada a cliente 2")
		Logger.log("Parece que a cliente 2 le ha gustado (qué mal gusto)")
		Global.dinero += int(satisfaccion * 100) 
		Logger.log("Haz ganado $" + str( satisfaccion * 100))
		Logger.log("Dinero actual: $"+str(Global.dinero))
	else:
		Logger.log("El cliente 2 se fue insatisfecho.")


func _on_area_atencion_cliente_area_entered(area: Area3D) -> void:
	pass # Replace with function body.
