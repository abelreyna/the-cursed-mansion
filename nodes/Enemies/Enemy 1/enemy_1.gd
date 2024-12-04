extends CharacterBody2D

var speed = 150
@onready var walking_sound = $AudioWalk
@onready var _terror1_sound = $Terror1
@onready var _terror2_sound = $Terror2

@export var player: Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

signal finAnimacionEnemy

var dir = global_position
var fade_out_speed = 1.0 / 5.0  # Velocidad de desvanecimiento para 5 segundos
var is_moving = false

var objetivo = global_position
func _ready() -> void:
	
	# Inicializa el volumen a su nivel normal
	walking_sound.volume_db = 0.0
	_terror1_sound.volume_db = 0.0
	_terror2_sound.volume_db = 0.0
	makepaht()
	
func desaparece_enemy() -> void:
	self.visible = false
	if player.luz.visible:
		self.visible = true
		
	else:
		self.visible = false
		
		
func _process(delta: float) -> void:
	desaparece_enemy()


func _physics_process(_delta: float) -> void:

	var was_moving = is_moving
	is_moving =  player.luz.visible and (player in $"VisiónRange".get_overlapping_bodies() or player in $"HitboxComponent".get_overlapping_bodies())
	dirigirse()

	if player.luz.visible and player in $"VisiónRange".get_overlapping_bodies():
		
		if player not in $"HitboxComponent".get_overlapping_bodies():
			speed = 300
			makepaht()
			# Reproduce animación de caminar
			$AnimEnemy.play("Walk")
			
		elif player in $"HitboxComponent".get_overlapping_bodies():
			
			$AnimEnemy.play("Attack")
			
			speed = 0
			
		# Reinicia los sonidos si el estado de movimiento cambió
		if not was_moving:
			_reset_sounds()
		
	else:
		speed = 0
		# Reproduce animación de descanso
		$AnimEnemy.play("Idle")
		var master_bus_index = AudioServer.get_bus_index("Master")
		AudioServer.set_bus_volume_db(master_bus_index, -20)  # Ajusta a -20 dB o cualquier valor deseado
		# Reduce el volumen de los sonidos gradualmente
		walking_sound.volume_db = lerp(walking_sound.volume_db, -80.0, _delta * fade_out_speed)
		_terror1_sound.volume_db = lerp(_terror1_sound.volume_db, -80.0, _delta * fade_out_speed)
		_terror2_sound.volume_db = lerp(_terror2_sound.volume_db, -80.0, _delta * fade_out_speed)
	
	# Ajusta la velocidad
	velocity = dir * speed
	
	# Gira al personaje dependiendo de su dirección en x
	voltear()
	
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

func dirigirse() -> void:
	var dist_nd_izq = self.global_position.distance_to(player.pos_izq.global_position)
	var dist_nd_der = self.global_position.distance_to(player.pos_der.global_position)
	
	if dist_nd_der > dist_nd_izq:
		objetivo = player.pos_izq.global_position
		#print("Dirigirse izquierda")
		
	if dist_nd_izq > dist_nd_der:
		objetivo = player.pos_der.global_position
		#print("Dirigirse derecha")

func makepaht() -> void:
	dir = self.global_position.direction_to(objetivo)
	
func voltear() -> void:
	if (self.global_position.direction_to(player.global_position).x < 0):
		$AnimEnemy.scale.x = -2
	else:
		$AnimEnemy.scale.x = 2


func _on_animacionFinish_Attack() -> void:
	var anifin = true
	finAnimacionEnemy.emit(anifin)
	pass # Replace with function body.
