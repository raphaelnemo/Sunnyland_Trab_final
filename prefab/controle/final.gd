extends Area2D

@onready var canvas_layer: CanvasLayer = $"../CanvasLayer" if has_node("../CanvasLayer") else get_node_or_null("../CanvasLayer")

# Define a ordem das funções que lidam com a fase sendo completada

#func _on_body_entered(body: Node2D) -> void:
#	if body.name == "jogador" or body.name == "Player" or body.is_in_group("jogador") or body.is_in_group("player"):
#		canvas_layer.mostrar_ganhou()
#		body.controlavel = false
#		
#		controladorFases.faseCompletada(controladorFases.idFaseAtual)
#		controladorFases.desbloquearFase(controladorFases.idFaseAtual + 1)
#		
#		await get_tree().create_timer(1.0).timeout
#		
#		controladorFases.fecharfase()
#		controladorFases.carregarFase(0)
		

func _on_body_entered(body: Node2D) -> void:
	print(">>> 1. SINAL DISPAROU COM: ", body.name, " | Grupos: ", body.get_groups())
	
	if body.name == "jogador" or body.name == "Player":
		print(">>> 2. PASSOU NO IF DO PLAYER!")
		
		if canvas_layer and canvas_layer.has_method("mostrar_ganhou"):
			print(">>> 3. CANVAS LAYER ENCONTRADO!")
			canvas_layer.mostrar_ganhou()
		else:
			print(">>> 3. AVISO: CANVAS LAYER É NULO OU NÃO TEM mostrar_ganhou")
			
		if "controlavel" in body:
			body.controlavel = false
		
		print(">>> 4. CHAMANDO CONTROLADOR...")
		if Engine.has_singleton("controladorFases") or get_node_or_null("/root/controladorFases"):
			var controlador = get_node("/root/controladorFases")
			controlador.faseCompletada(controlador.idFaseAtual)
			controlador.desbloquearFase(controlador.idFaseAtual + 1)
			
			await get_tree().create_timer(1.0).timeout
			
			controlador.fecharfase()
			controlador.carregarFase(0)
		else:
			print(">>> 4. AVISO: controladorFases não encontrado no /root/")
