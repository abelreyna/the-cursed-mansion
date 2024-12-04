extends Area2D


# Ruta de la escena a cargar
@export var change_scene = preload("res://Dialogos/Salida.tscn")

# Referencia al área
# Función de inicialización
func _ready():
	# Conecta la señal 'body_entered' a la función '_load_next_level'
	body_entered.connect(khe)

# Cargamos el siguiente nivel (la siguiente escena)
func khe(body):
	# Asegúrate de que el cuerpo que entra es el jugador u otro objeto específico
	if body.name == "Character_main":
		get_tree().change_scene_to_packed(change_scene)
