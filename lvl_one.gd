extends Node3D

@onready var output_label: TextEdit = $CanvasLayer/TextEdit


@onready var DineroLabel: Label = $CanvasLayer2/HBoxContainer/Panel/DineroLabel
@onready var ChanguasLabel: Label = $CanvasLayer2/HBoxContainer/Panel/ChanguasLabel
@onready var CpsLabel: Label = $CanvasLayer2/HBoxContainer/Panel/CpsLabel

func _ready():
	# Conectar la señal para actualizar el recuadro de texto usando Callable
	Logger.mensaje_agregado.connect(_actualizar_output)

func _actualizar_output(mensaje: String):
	output_label.text += mensaje + "\n"  # Agregar el mensaje al recuadro
	# Limitar el número de mensajes mostrados
	var lineas = output_label.text.split("\n")
	if lineas.size() > 4:
		output_label.text = "\n".join(lineas.slice(-4))  # Mostrar solo las últimas 10 líneas
		
		
func _process(delta):
	# Actualizar los Label con los valores globales
	DineroLabel.text = "Dinero: $%d" % Global.dinero
	ChanguasLabel.text = "Changuas: %d" % Global.changuas_listas
	CpsLabel.text = "cps: %.1f" % Global.cps
