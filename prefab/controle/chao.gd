extends Area2D

@onready var canvas_layer: CanvasLayer = $"../CanvasLayer"

func _eh_jogador(body: Node2D) -> bool:
	return JogadorCompat.eh_jogador(body)

# Lida com oque acontece com o jogador se ele cair para fora do mapa
func _on_body_entered(body : Node2D) -> void:
	if _eh_jogador(body):
		canvas_layer.mostrar_morreu()
		await get_tree().create_timer(1.0).timeout
		if body.has_method("resetar"):
			body.resetar()
		canvas_layer.esconder_tudo()
