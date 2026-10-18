extends Control

func _on_voltar_pressed() -> void:
	controladorFases.fecharfase()
	get_tree().change_scene_to_file("res://principal.tscn")

func _on_1_pressed() -> void:
	controladorFases.carregarFase(1)

func _on_button_2_pressed() -> void:
	controladorFases.carregarFase(2)

func _on_button_3_pressed() -> void:
	controladorFases.carregarFase(3)

func _on_button_4_pressed() -> void:
	controladorFases.carregarFase(4)

func _on_button_5_pressed() -> void:
	controladorFases.carregarFase(5)
