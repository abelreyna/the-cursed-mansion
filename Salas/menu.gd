extends Control


func _on_btn_play_pressed():
	get_tree().change_scene_to_file("res://Salas/Intro.tscn")


func _on_btn_instruc_pressed():
	get_tree().change_scene_to_file("res://Dialogos/Instruciones.tscn")
	


func _on_btn_exit_pressed():
	get_tree().quit()
