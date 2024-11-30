extends Node2D

# Variables
@onready var texture_rect = $TextureRect  # Nodo para la imagen de fondo
@onready var animation = $TextureRect/AnimationPlayer

# Escenas y diálogos a reproducir
var scenes = [
	{"image": "res://Assets/GUI/Imgs_Intro/Escena1.jpeg", "dialogue": "Escena1"},
	{"image": "res://Assets/GUI/Imgs_Intro/Escena2.jpeg", "dialogue": "Escena2"},
	{"image": "res://Assets/GUI/Imgs_Intro/Escena3.jpeg", "dialogue": "Escena3"},
	{"image": "res://Assets/GUI/Imgs_Intro/Escena4.jpeg", "dialogue": "Escena4"},
	{"image": "res://Assets/GUI/Imgs_Intro/Escena5.jpeg", "dialogue": "Escena5"},
]

var current_scene_index = 0  # Índice de la escena actual

func _ready():
	# Configurar para abarcar toda la pantalla
	texture_rect.expand_mode = texture_rect.EXPAND_FIT_WIDTH_PROPORTIONAL
	#texture_rect.rect_size = get_viewport().size
	
	# Comenzar desde la primera escena
	play_scene(current_scene_index)
	# Comenzar desde la primera escena con una animación
	animation.play("Aparicion de escenas")

# Función para reproducir una escena
func play_scene(index: int):
	if index >= scenes.size():
		print("Todas las escenas han terminado.")
		return

	# Cargar la escena actual
	var scene_data = scenes[index]	
	var new_texture = load(scene_data["image"])
	if new_texture:
		texture_rect.texture = new_texture
		print("Imagen cargada:", scene_data["image"])
	else:
		print("Error al cargar la imagen:", scene_data["image"])
	
	# Mostrar el diálogo correspondiente
	DialogueManager.show_example_dialogue_balloon(
		load("res://Dialogos/Intro.dialogue"), 
		scene_data["dialogue"]
	)

# Callback cuando termina un diálogo
func _on_dialogue_ended(resource: DialogueResource):
	print("Diálogo finalizado. Cambiando a la siguiente escena.")
	current_scene_index += 1
	play_scene(current_scene_index)

func change_scene():
	get_tree().change_scene_to_file("res://Salas/scena_1.tscn")
