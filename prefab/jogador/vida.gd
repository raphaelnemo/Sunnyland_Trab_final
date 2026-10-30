extends Node

@onready var jogador: CharacterBody2D = null
@onready var lista_pontos : Array = [
	$Ui/vida/HBoxContainer/ponto1,
	$Ui/vida/HBoxContainer/ponto2,
	$Ui/vida/HBoxContainer/ponto3
]

var vida_anterior : int = -1

func _ready() -> void:
	buscar_jogador()

func buscar_jogador() -> void:
	if is_instance_valid(jogador):
		return
	jogador = get_tree().get_first_node_in_group("jogador")
	if not is_instance_valid(jogador):
		jogador = get_tree().get_first_node_in_group("player")
	if not is_instance_valid(jogador) and is_inside_tree() and get_tree() and get_tree().current_scene:
		var player_por_nome = get_tree().current_scene.find_child("jogador", true, false)
		if not player_por_nome:
			player_por_nome = get_tree().current_scene.find_child("Player", true, false)
		if player_por_nome is CharacterBody2D:
			jogador = player_por_nome

# ----- Bloco _physics_process - Atualia a todo frame -----
func _process(_delta: float) -> void:
	buscar_jogador()
	if not is_instance_valid(jogador):
		return

	# Monitora se a vida atual mudou para esconder/mostrar as ponto/cereja preenchidos
	var vida_jogador = jogador.get("vida_atual") if jogador.has_method("get") else null
	if vida_jogador != null and vida_jogador != vida_anterior:
		vida_anterior = int(vida_jogador)
		atualizar_vida_ui(vida_anterior)
# ----- Bloco _physics_process - Atualia a todo frame -----

# Função que atualiza o quanto de vida é mostrada na Ui
func atualizar_vida_ui(vida_atual: int) -> void:
	for i in range(lista_pontos.size()):
		if i < lista_pontos.size() and lista_pontos[i] != null:
			lista_pontos[i].visible = i < vida_atual

func _eh_jogador(body: Node2D) -> bool:
	return JogadorCompat.eh_jogador(body)

# função que recebe e repassa o sinal de dano
func _on_gamba_jogador_dano(body) -> void:
	if _eh_jogador(body):
		if body.has_method("perder_vida"):
			body.perder_vida(1)

# função que recebe e repassa o sinal de recuperacao
func _on_cereja_jogador_recuperacao(body) -> void:
	if _eh_jogador(body):
		if body.has_method("ganhar_vida"):
			body.ganhar_vida(1)
