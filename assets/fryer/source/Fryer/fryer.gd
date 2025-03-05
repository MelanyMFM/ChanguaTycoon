#extends StaticBody3D
extends Node3D
signal changua_lista

var esta_cocinando: bool = false

@onready var efecto_sonido: AudioStreamPlayer3D = get_node("../AudioStreamPlayer3D3")
#get_node("../AudioStreamPlayer3D3")

func empezar_a_cocinar():
	esta_cocinando = true
	Logger.log("Cocinando changua...")
	await get_tree().create_timer(Global.cps).timeout # Espera a que el temporizador termine
	esta_cocinando = false
	Logger.log("Changua lista.")
	efecto_sonido.play()
	Global.changuas_listas = Global.changuas_listas + 1
	emit_signal("changua_lista")


func _on_static_body_3d_input_event(camera, event, event_position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and not esta_cocinando:
			empezar_a_cocinar()
