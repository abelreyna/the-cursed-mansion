extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	_dead()
	pass

func _dead():
	$"AnimNiña".speed_scale = 0.30
	$"AnimNiña".play("dead")
	
	if $DirectionalLight2D.energy >= 0:
		$DirectionalLight2D.energy = $DirectionalLight2D.energy - 0.01

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.visible == true:
		_dead()
		if $"AnimNiña".frame == 12:
			$"AnimNiña".frame_progress = 0
	pass
