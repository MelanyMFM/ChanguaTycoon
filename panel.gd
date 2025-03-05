extends Panel

@export var costo_mejora: int = 50  # Costo de la mejora
@export var aumento_cps: float = 0.005  # Cuánto aumenta el cps

@onready var costo_label: Label = $Precio
@onready var comprar_button: Button = $Button

@onready var efecto_sonido: AudioStreamPlayer3D = get_node("../../AudioStreamPlayer3D2")

var max = 2

func _ready():
	actualizar_ui()

func actualizar_ui():
	# Actualizar el Label con el costo de la mejora
	costo_label.text = "Costo: $%d" % costo_mejora



func _on_button_pressed():
	if max > 0:
		
		if Global.dinero >= costo_mejora:
			Global.dinero -= costo_mejora
			
			Global.cps -= (1/(1-aumento_cps))
			
			actualizar_ui()
			Logger.log("Mejora comprada!")
			efecto_sonido.play()
			max -= 1
		else:
			Logger.log("No tienes suficiente dinero :(")
	else:
		Logger.log("No puedes mejorar más")


func _on_texture_button_pressed():
	visible = not visible  # Mostrar u ocultar la tienda
