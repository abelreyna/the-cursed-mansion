extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_character_main_barra(vida: int) -> void:
	#print("llego papa: ", vida)
	$barraCordura.value = vida


func _on_character_main_barra_energia(energia: int) -> void:
	print("llego otra vez: ", energia)
	$barraEnergia.value = energia
