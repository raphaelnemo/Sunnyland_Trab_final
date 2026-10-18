class_name fase
extends Node

# Atrela uma fase a um id

@export var idFase : int
@export var jogadorInicio : Node2D
var dadoFase : dadosFase

func _ready() -> void:
	dadoFase = controladorFases.carregarDados(idFase)


func _on_gamba_jogador_dano(body: Variant) -> void:
	pass # Replace with function body.
