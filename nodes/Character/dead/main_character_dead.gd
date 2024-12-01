extends Node2D
var countLevel = 0

@onready var screamer = $Screamer;

var fade_out_speed = 1.0 / 5.0
# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	$"AnimNiña".speed_scale = 0;
	_dead()
	
	pass

func _dead():
	$"AnimNiña".speed_scale = 0.30
	$"AnimNiña".play("dead")
	
	if $DirectionalLight2D.energy >= 0:
		$DirectionalLight2D.energy = $DirectionalLight2D.energy - 0.01

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if self.visible == true:
		countLevel = countLevel + 1;
		print(countLevel)
		_dead()
		if $"AnimNiña".frame == 12:
			$"AnimNiña".frame_progress = 0
			$"AnimNiña".frame = 12
			$Fondo.play("default")
			
			#Reprocuce el sonido
			screamer.play()
			
			#Ejecuta animación
			$"AnimNiña".global_position -= Vector2(0.5,15)
			$"AnimNiña".global_position += Vector2(randf_range(-10.0, 10.0),randf_range(-5.0, 5.0))
			$"AnimNiña".scale += Vector2(0.5,0.5)
			
			
		if countLevel == 500:
			get_tree().reload_current_scene()
	pass
