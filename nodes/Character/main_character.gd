extends CharacterBody2D

const SPEED = 450

@onready var walking_sound = $AudioWalk
@onready var luz := $PointLight2D as PointLight2D
@onready var light_on_sound = $AudioLightOn
@onready var light_off_sound = $AudioLightOff

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
					$"AnimNiña".play("walk_right_down")
				if dir.y < 0:
					$"AnimNiña".play("walk_right_up")
			else:
				if dir.y > 0 or dir.y == 0:
					$"AnimNiña".play("walk_left_down")
				if dir.y < 0:
					$"AnimNiña".play("walk_left_up")
		else:
			if dir.y > 0:
				$"AnimNiña".play("walk_down")
			else:
				$"AnimNiña".play("walk_up")
	else:
		# Detener el sonido de caminar si el personaje está quieto
		if walking_sound.playing:
			walking_sound.stop()
		$"AnimNiña".play("Idle")
		
	velocity = dir.normalized() * SPEED
	move_and_slide()
