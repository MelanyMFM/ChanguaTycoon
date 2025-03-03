extends Control

func _on_button_pressed():
	# Cambiar a la escena de la secuencia de imágenes
	get_tree().change_scene_to_file("res://historia.tscn")
