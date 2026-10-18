extends Node

@export var idFase : int
@export var jogadorInicio : Node2D

var dadoFase : dadosFase

func _ready() -> void:
	dadoFase = controladorFases.carregarDados(idFase)
