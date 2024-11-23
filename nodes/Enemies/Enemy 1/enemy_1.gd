extends CharacterBody2D

var speed = 100
@onready var walking_sound = $AudioWalk
@onready var _terror1_sound = $Terror1
@onready var _terror2_sound = $Terror2

@export var player: Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

var dir = global_position
var fade_out_speed = 1.0 / 5.0  # Velocidad de desvanecimiento para 5 segundos
var is_moving = false

func _ready() -> void:
	# Inicializa el volumen a su nivel normal
	walking_sound.volume_db = 0.0
	_terror1_sound.volume_db = 0.0
	_terror2_sound.volume_db = 0.0
	makepaht()

func _physics_process(_delta: float) -> void:
	var was_moving = is_moving
	is_moving = player.luz.visible and player in $Area2D.get_overlapping_bodies()
	
	if is_moving:
		makepaht()
		# Reproduce animación de caminar
		$AnimEnemy.play("Walk")
		speed = 300

		# Reinicia los sonidos si el estado de movimiento cambió
		if not was_moving:
			_reset_sounds()
	else:
		speed = 0
		# Reproduce animación de descanso
		$AnimEnemy.play("Idle")
		
		# Reduce el volumen de los sonidos gradualmente
		walking_sound.volume_db = lerp(walking_sound.volume_db, -80.0, _delta * fade_out_speed)
		_terror1_sound.volume_db = lerp(_terror1_sound.volume_db, -80.0, _delta * fade_out_speed)
		_terror2_sound.volume_db = lerp(_terror2_sound.volume_db, -80.0, _delta * fade_out_speed)
	
	# Ajusta la velocidad
	velocity = dir * speed
	
	# Gira al personaje dependiendo de su dirección en x
	if (dir.x < 0):
		$AnimEnemy.scale.x = -2
	else:
		$AnimEnemy.scale.x = 2
	
	move_and_slide()

func _reset_sounds() -> void:
	# Reinicia el volumen y reproduce los sonidos desde el principio
	walking_sound.stop()
	_terror1_sound.stop()
	_terror2_sound.stop()

	walking_sound.volume_db = 0.0
	_terror1_sound.volume_db = 0.0
	_terror2_sound.volume_db = 0.0

	walking_sound.play()
	_terror1_sound.play()
	_terror2_sound.play()

func makepaht() -> void:
	dir = self.global_position.direction_to(player.global_position)
