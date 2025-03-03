extends Node

signal mensaje_agregado(mensaje: String)

var mensajes: Array = []

func log(mensaje):
	mensajes.append(mensaje)
	print(mensaje)  # También imprime en la consola
	emit_signal("mensaje_agregado", mensaje)  # Notificar que se agregó un mensaje
