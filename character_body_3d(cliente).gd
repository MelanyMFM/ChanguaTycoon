extends CharacterBody3D

var esta_pidiendo_changua: bool = false
var changua_lista: bool = false
var tiempo_llegada: float = 0.0
var tiempo_espera_maximo: float = 30  # Tiempo máximo que el cliente esperará

func _ready():
	tiempo_llegada = Time.get_ticks_msec() / 1000.0  # Registrar el tiempo de llegada
	print("Dinero actual: $", Global.dinero)

func _process(delta):
	if esta_pidiendo_changua:
		var tiempo_actual = Time.get_ticks_msec() / 1000.0
		if tiempo_actual - tiempo_llegada > tiempo_espera_maximo:
			print("El cliente se fue insatisfecho.")
			queue_free()  # Eliminar al cliente de la escena


func _on_area_3d_body_entered(body):
	print(body.name)
	if body.name == "CharacterBody3D":  # Asegúrate de que el jugador tenga el nombre correcto
		
		
		if esta_pidiendo_changua == false:
			esta_pidiendo_changua = true
			print("El cliente está pidiendo changua.")
			
		else:
			recibir_changua()
	
func _on_estufa_changua_lista():
	changua_lista = true
	print("La changua está lista para entregar.")
	
	
func recibir_changua():
	if Global.changuas_listas >= 1:  # Solo entregar si la changua está lista
		entregar_changua()
	else:
		print("La changua no está lista todavía.")

func entregar_changua():
	Global.changuas_listas -= 1
	var tiempo_actual = Time.get_ticks_msec() / 1000.0
	var tiempo_espera = tiempo_actual - tiempo_llegada

	if tiempo_espera <= tiempo_espera_maximo:
		var satisfaccion = 1.0 - (tiempo_espera / tiempo_espera_maximo)
		print("Changua entregada")
		print("Satisfacción del cliente: ", satisfaccion)
		Global.dinero += int(satisfaccion * 100) 
		print("Haz ganado $", satisfaccion * 100)
		print("Dinero actual: $", Global.dinero)
	else:
		print("El cliente se fue insatisfecho.")
	queue_free()  # Eliminar al cliente de la escena
