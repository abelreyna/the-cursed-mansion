extends Node2D

var sum: bool =  true
signal bateria
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	$AnimatedSprite2D.play("pila")

func _process(delta: float) -> void:
	pass
	
func _on_area_2d_area_entered(body) -> void:
	if sum:
		bateria.emit()
	$AnimatedSprite2D.play("desaparece")

func _on_animated_sprite_2d_animation_finished() -> void:
	self.queue_free()
