extends Area2D

@onready var canvas_layer: CanvasLayer = $"../CanvasLayer" if has_node("../CanvasLayer") else get_node_or_null("../CanvasLayer")

func _eh_jogador(body: Node2D) -> bool:
	return JogadorCompat.eh_jogador(body)

func _on_body_entered(body: Node2D) -> void:
	if _eh_jogador(body):
		if canvas_layer and canvas_layer.has_method("mostrar_ganhou"):
			canvas_layer.mostrar_ganhou()
		if "controlavel" in body:
			body.controlavel = false
		if Engine.has_singleton("controladorFases") or get_node_or_null("/root/controladorFases"):
			var controlador = get_node("/root/controladorFases")
			controlador.faseCompletada(controlador.idFaseAtual)
			controlador.desbloquearFase(controlador.idFaseAtual + 1)
			await get_tree().create_timer(1.0).timeout
			controlador.fecharfase()
			controlador.carregarFase(0)
