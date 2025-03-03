#extends StaticBody3D
extends Node3D
signal changua_lista

var esta_cocinando: bool = false


func empezar_a_cocinar():
	esta_cocinando = true
	print("Cocinando changua...")
	await get_tree().create_timer(3.0).timeout # Espera a que el temporizador termine
	esta_cocinando = false
	print("Changua lista.")
	Global.changuas_listas = Global.changuas_listas + 1
	emit_signal("changua_lista")


func _on_static_body_3d_input_event(camera, event, event_position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and not esta_cocinando:
			empezar_a_cocinar()
