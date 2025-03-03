extends Node3D

@onready var output_label: TextEdit = $CanvasLayer/TextEdit

func _ready():
	# Conectar la señal para actualizar el recuadro de texto usando Callable
	Logger.mensaje_agregado.connect(_actualizar_output)

func _actualizar_output(mensaje: String):
	output_label.text += mensaje + "\n"  # Agregar el mensaje al recuadro
	# Limitar el número de mensajes mostrados
	var lineas = output_label.text.split("\n")
	if lineas.size() > 4:
		output_label.text = "\n".join(lineas.slice(-4))  # Mostrar solo las últimas 10 líneas
