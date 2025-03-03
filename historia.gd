extends CanvasLayer

var imagenes: Array = [
	"res://assets/historia/Start-screen.png",
	"res://assets/historia/2screen.png",
]
var indice_imagen: int = 0
@onready var texture_rect: TextureRect = $TextureRect
@onready var flecha: TextureButton = $TextureButton

func _ready():
	mostrar_siguiente_imagen()
	
func _on_texture_button_pressed():
	mostrar_siguiente_imagen()

func mostrar_siguiente_imagen():
	if indice_imagen < imagenes.size():
		texture_rect.texture = load(imagenes[indice_imagen])
		indice_imagen += 1
		
		
	else:
		# Cambiar al nivel cuando termine la secuencia
		if indice_imagen >= imagenes.size():
			flecha.visible = false
		get_tree().change_scene_to_file("res://Lvl_One.tscn")
		
