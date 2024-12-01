extends CharacterBody2D

const SPEED = 450

@onready var walking_sound = $AudioWalk
@onready var luz := $PointLight2D as PointLight2D
@onready var light_on_sound = $AudioLightOn
@onready var light_off_sound = $AudioLightOff

signal barra
signal barraEnergia



#nodoizq y der
@onready var pos_izq = $izq
@onready var pos_der = $der

var healt: int = 100

@onready var point_light = $PointLight2D  #  la ruta correcta al PointLight2D
@onready var timer = $Timer  #  la ruta correcta al Timer

var timer_energy: Timer
var energia : int = 100 
var verificaLuz :bool 

#Función para sumar energia
func _on_bateria_bateria() -> void:
 # Aumenta la energía solo si es menor a 100
	if verificaLuz is bool:
		if energia < 100:
			energia += 10  # Incrementa la energía en 10 puntos

		# Asegúrate de que no sobrepase 100
		if energia > 100:
			energia = 100
		
		# Emitir la señal y mostrar la energía total
		barraEnergia.emit(energia)
		print("Energía total= ", energia)
		

# Función que se llama cuando el nodo está listo (cuando se ha agregado a la escena).
func _ready() -> void:
	
	# Conecta la señal "light_state_changed" del nodo point_light a la función "_on_light_state_changed".
	# Esto permite que la función se ejecute cada vez que cambia el estado de la luz.
	point_light.connect("light_state_changed", Callable(self, "_on_light_state_changed"))
	
		# Conecta la señal "timeout" del Timer a la función "_on_timer_timeout".
	# Esto permite que la función se ejecute cada vez que el Timer se agota.
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	# Establece el tiempo de espera del Timer en 2 segundos.
	timer.wait_time = 2.0  
	
	# Crear y configurar el Timer para la energía
	timer_energy = Timer.new()
	timer_energy.wait_time = 1.0  # Establece el tiempo de espera del Timer de energía en 1 segundo.
	timer_energy.connect("timeout", Callable(self, "_on_timer_energy_timeout"))
	add_child(timer_energy)  # Añadir el Timer de energía a la escena
	timer_energy.start()  # Iniciar el Timer de energía

	
	
	
# Función que se llama cuando cambia el estado de la luz.
func _on_light_state_changed(is_on: bool) -> void:
	# Verifica si la luz está encendida.
	if is_on:
		verificaLuz = true

		#print("La luz está encendida.", healt)  # Imprime un mensaje indicando que la luz está encendida y muestra la salud actual.
		timer.stop()  # Detiene el Timer si la luz está encendida para evitar reducir salud.
	else:
		verificaLuz = false
		
		#print("La luz está apagada.")  # Imprime un mensaje indicando que la luz está apagada.
		timer.start()  # Inicia el Timer si la luz está apagada, comenzando el conteo para reducir salud.

# Función que se llama cuando el Timer se agota.
func _on_timer_timeout() -> void:

	healt -= 1  # Resta 1 a la salud cada vez que el Timer se agota (cada 2 segundos).
	#print("Salud reducida:", healt)  # Imprime un mensaje mostrando la nueva cantidad de salud.

	# Verifica si la salud ha llegado a 0 o menos.
	if healt <= 0:
		healt = 0  # Asegúrate de no tener salud negativa, establece salud en 0.
		dead()  # Llama a una función para manejar la muerte del personaje.
	if healt >= 100:
		healt =100
		
	barra.emit(healt)
		
# Función que se llama cuando el Timer de energía se agota.
func _on_timer_energy_timeout() -> void:
	if point_light.visible and energia > 0:
		energia -= 1  # Disminuye energía en 2 unidades si la luz está encendida.
		barraEnergia.emit(energia)
		healt += 1     # Aumenta salud en 1 unidad si la luz está encendida.
		barra.emit(healt)
		
		#print("Energía reducida:", energia)   # Imprime un mensaje mostrando la nueva cantidad de energía.
		#print("Salud aumentada:", healt)       # Imprime un mensaje mostrando la nueva cantidad de salud.

		if energia <= 0:
			energia = 0
			point_light.visible = false  # Apaga la luz si se agota la energía.


# Función que maneja lo que sucede cuando el personaje muere.
func dead():
	#print("El personaje ha muerto.")  # Imprime un mensaje indicando que el personaje ha muerto.
	pass
# Función que se llama en cada frame. El parámetro delta representa el tiempo transcurrido desde el último frame.
func _process(delta: float) -> void:
	# Verifica si la acción "light" ha sido presionada en este frame.
	# Asegúrate de que esta acción esté definida en el Input Map del proyecto.
	if Input.is_action_just_pressed("light"):  
		toggle_light()  # Llama a toggle_light para alternar el estado de la luz.
# Función para alternar la visibilidad de la luz.
func toggle_light() -> void:
	point_light.toggle_visibility()  # Llama al método toggle_visibility del nodo point_light para cambiar su estado.
# Función que se llama cuando cambia el estado de la luz.


func _on_health_component_on_damagetook() -> void:
	#print("Se ha recibido daño.")
	healt -= 10
	barra.emit(healt)


func _on_health_component_on_dead() -> void:
	#print("El objeto ha muerto.")
	pass


func _on_health_component_on_health_change(healt: int) -> void:
	#print("La salud ha cambiado a: ", healt)
	pass




func _physics_process(delta):
	var dir: Vector2 = Input.get_vector("izquierda", "derecha", "arriba", "abajo")
	
	# Cambiar visibilidad de la linterna y reproducir sonido correspondiente
	if Input.is_action_just_pressed("light"):
		luz.visible = !luz.visible
		if luz.visible:
			light_on_sound.play()
		else:
			light_off_sound.play()
	
	# Movimiento del personaje
	if dir:
		# Reproducir sonido de caminar si no está ya en reproducción
		if not walking_sound.playing:
			walking_sound.play()
			
		if dir.x != 0:
			if dir.x > 0:
				if dir.y > 0 or dir.y == 0:
					if !luz.visible:
						$"AnimNiña".play("walk_right_down")
					else:
						$"AnimNiña".play("walk_right_down_light")
				if dir.y < 0:
					if !luz.visible:
						$"AnimNiña".play("walk_right_up")
					else:
						$"AnimNiña".play("walk_right_up_light")
			else:
				if dir.y > 0 or dir.y == 0:
					if !luz.visible:
						$"AnimNiña".play("walk_left_down")
					else:
						$"AnimNiña".play("walk_left_down_light")
				if dir.y < 0:
					if !luz.visible:
						$"AnimNiña".play("walk_left_up")
					else:
						$"AnimNiña".play("walk_left_up_light")
		else:
			if dir.y > 0:
				if !luz.visible:
					$"AnimNiña".play("walk_down")
				else:
					$"AnimNiña".play("walk_down_light")
			else:
				if !luz.visible:
					$"AnimNiña".play("walk_up")
				else:
					$"AnimNiña".play("walk_up_light")
	else:
		# Detener el sonido de caminar si el personaje está quieto
		if walking_sound.playing:
			walking_sound.stop()
		if !luz.visible:
			$"AnimNiña".play("Idle")
		else:
			$"AnimNiña".play("Idle_light")
		
	velocity = dir.normalized() * SPEED
	move_and_slide()
