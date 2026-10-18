extends Node

@export var fasesDisponiveis : Array[dadosFase]
@onready var node_2d: Node2D = $Node2D

func _ready() -> void:
	controladorFases.principal = node_2d
	controladorFases.fasesDisponiveis = fasesDisponiveis
	_setup_level()

func _setup_level() -> void: 
	var Inimigos = $Node2D.get_node_or_null("Inimigos")
	if Inimigos:
		for inimigo in Inimigos.get_children():
			inimigo.jogadorDano.connect()
