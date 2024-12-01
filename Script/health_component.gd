extends Area2D

# Define la clase HealthComponent, que puede ser utilizada como un componente de salud en otros nodos.
class_name HealthComponent

# Señales que se emitirán cuando ocurran ciertos eventos relacionados con la salud.
signal onDead  # Se emite cuando el personaje muere.
signal onDamagetook  # Se emite cuando el personaje recibe daño.
signal onHealthChange(healt: int)  # Se emite cuando cambia la salud, pasando el nuevo valor.

# Propiedad exportada que define la salud máxima del personaje. Se puede ajustar desde el editor.
@export var max_health: int = 100 

# Variable que almacena la salud actual del personaje, inicializada en 0.
var current_health: int = 0 

# Variable que almacena la salud anterior antes de realizar cambios.
var old_health: int

# Función que se llama cuando el nodo está listo (cuando se ha agregado a la escena).
func _ready() -> void:
	current_health = max_health  # Inicializa la salud actual al valor máximo al comenzar.

# Función para curar al personaje, aumentando su salud.
func take_heal(value: int):
	set_health(value)  # Llama a set_health con el valor de curación.

# Función para aplicar daño al personaje, reduciendo su salud.
func take_damage(damage: int):
	var value = abs(damage)  # Asegura que el daño sea un número positivo.
	set_health(-value)  # Llama a set_health con un valor negativo para disminuir la salud.

# Función para establecer la salud del personaje.
func set_health(value: int):
	old_health = current_health  # Guarda el valor actual de la salud antes de cambiarlo.
	current_health += value  # Ajusta la salud actual sumando el valor proporcionado.
	current_health = clamp(current_health, 0, max_health)  # Limita la salud entre 0 y max_health.
	# Verifica si ha habido un cambio en la salud actual.
	if old_health != current_health:
		onHealthChange.emit(current_health)  # Emite una señal con el nuevo valor de salud.
	# Verifica si el personaje ha muerto (salud menor o igual a 0).
	if current_health <= 0:
		dead()  # Llama a la función dead() si la salud es menor o igual a 0.
		return  # Sale de la función para evitar ejecutar más código.
	# Verifica si se ha recibido daño y aún está vivo.
	elif current_health >= 0 and current_health < old_health:
		onDamagetook.emit()  # Emite una señal indicando que se ha recibido daño.

# Función que maneja la lógica al morir.
func dead():
	onDead.emit()  # Emite una señal indicando que el personaje ha muerto.
