#extends StaticBody3D
extends Node3D
signal changua_lista

var esta_cocinando: bool = false
@export var distancia_minima: float = 0.35  # Distancia mínima para cocinar

@onready var sonido_coccion: AudioStreamPlayer3D = get_node("../AudioCocinar")
@onready var personaje = get_node("../CharacterBody3D")
@onready var efecto_sonido: AudioStreamPlayer3D = get_node("../AudioStreamPlayer3D3")
#get_node("../AudioStreamPlayer3D3")

func empezar_a_cocinar():
	esta_cocinando = true
	Logger.log("Cocinando changua...")
	# Reproducir sonido de cocción en bucle
	sonido_coccion.play()
	
	await get_tree().create_timer(Global.cps).timeout # Espera a que el temporizador termine
	esta_cocinando = false
	Logger.log("Changua lista.")
	sonido_coccion.stop()
	efecto_sonido.play()
	Global.changuas_listas = Global.changuas_listas + 1
	emit_signal("changua_lista")


func _on_static_body_3d_input_event(camera, event, event_position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and not esta_cocinando:
			# Verificar si el personaje está cerca antes de cocinar
			var distancia = global_transform.origin.distance_to(personaje.global_transform.origin)
			if distancia <= distancia_minima:
				empezar_a_cocinar()
			else:
				Logger.log("Estás demasiado lejos para cocinar.")
