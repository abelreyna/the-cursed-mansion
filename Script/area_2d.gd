extends Area2D


# Ruta de la escena a cargar
@export var _path_to_scene = ""

# Referencia al area
@onready var _area = $Area2D


# Función de inicialización
func _ready():
	_area.body_entered.connect(_load_nex_level)


# Cargamos el siguiente nivel (la siguiente escena)
func _load_nex_level(body):
	# Cambiamos de escena si la ruta no está vacía y el personaje principa entra en contacto
	if _path_to_scene != "" and body.is_in_group("player"):
		SceneTransition.change_scene(_path_to_scene)
