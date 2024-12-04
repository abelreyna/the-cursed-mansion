extends Node2D

# Ruta de la escena a cargar
@export var _path_to_scene = "res://Dialogos/Salida.tscn"

# Referencia al área
@onready var _area = $Area2D

# Función de inicialización
func _ready():
	# Conecta la señal 'body_entered' a la función '_load_next_level'
	_area.body_entered.connect(_load_next_level)

# Cargamos el siguiente nivel (la siguiente escena)
func _load_next_level(body):
	# Asegúrate de que el cuerpo que entra es el jugador u otro objeto específico
	if body.name == "Player":
		get_tree().change_scene(_path_to_scene)
