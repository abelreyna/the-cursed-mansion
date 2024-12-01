extends Area2D
class_name HitboxComponent

@export var damage: int = 10


func _ready() -> void:
	area_entered.connect(hit)

func hit(cuerpo):
	if cuerpo is HealthComponent:
		cuerpo.take_damage(damage)
