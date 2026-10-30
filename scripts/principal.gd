extends Node

@export var fasesDisponiveis : Array[dadosFase]
@onready var node_2d: Node2D = $Node2D

func _ready() -> void:
	if not is_instance_valid(controladorFases):
		return
	controladorFases.principal = node_2d
	controladorFases.fasesDisponiveis = fasesDisponiveis
	_setup_level()

func _setup_level() -> void:
	var inimigos = get_tree().get_nodes_in_group("inimigos")
	for inimigo in inimigos:
		if inimigo.has_signal("jogadorDano") and not inimigo.jogadorDano.is_connected(_on_jogador_dano):
			inimigo.jogadorDano.connect(_on_jogador_dano)

func _on_jogador_dano(body: Node2D) -> void:
	if body == null:
		return
	if body.has_method("perder_vida"):
		body.perder_vida(1)
