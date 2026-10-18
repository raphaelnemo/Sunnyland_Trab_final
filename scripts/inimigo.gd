extends Area2D
# Base dos inimigos (gamba, sapo): dano ao jogador e pisão.
# Herdado por "extends" com caminho (res://scripts/inimigo.gd), sem class_name.

# Enviado quando o jogador encosta no inimigo sem pisar nele
signal jogadorDano(body)

# Nó removido quando o inimigo morre (vazio = o próprio nó)
@export var raiz : Node
# Tolerância (px) para considerar que os pés do jogador estavam no topo do inimigo
@export var margemPisao : float = 10.0
# Velocidade vertical dada ao jogador ao pisar no inimigo
@export var forcaQuique : float = -250.0

var morto : bool = false

func _on_body_entered(body: Node2D) -> void:
	# Só reage ao jogador (ignora o TileMap e outros corpos)
	var corpo := body as CharacterBody2D
	if morto or corpo == null or corpo.name != "jogador":
		return
	if _pisou(corpo):
		morto = true
		if corpo.has_method("quicar"):
			corpo.quicar(forcaQuique)
		if raiz:
			raiz.queue_free()
		else:
			queue_free()
	else:
		jogadorDano.emit(corpo)

# Pisão = jogador caindo e com os pés (base da colisão) perto do topo da colisão do inimigo.
# Usa as formas de colisão reais, então não depende de onde fica a origem de cada nó.
func _pisou(corpo: CharacterBody2D) -> bool:
	if corpo.velocity.y <= 0.0:
		return false
	var formaJogador : CollisionShape2D = corpo.get_node("CollisionShape2D")
	var formaInimigo : CollisionShape2D = get_node("CollisionShape2D")
	var pes : float = formaJogador.global_position.y + _meiaAltura(formaJogador)
	var topo : float = formaInimigo.global_position.y - _meiaAltura(formaInimigo)
	return pes <= topo + margemPisao

func _meiaAltura(forma: CollisionShape2D) -> float:
	var s = forma.shape
	if s is RectangleShape2D:
		return s.size.y * 0.5
	if s is CapsuleShape2D:
		return s.height * 0.5
	if s is CircleShape2D:
		return s.radius
	return 8.0
