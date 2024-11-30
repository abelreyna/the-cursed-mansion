extends Control


func _on_btn_play_pressed():
	get_tree().change_scene_to_file("res://Salas/Intro.tscn")


func _on_btn_instruc_pressed():
	pass # Replace with function body.


func _on_btn_exit_pressed():
	get_tree().quit()
