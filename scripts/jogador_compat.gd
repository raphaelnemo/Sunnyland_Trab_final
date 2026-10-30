class_name JogadorCompat
extends RefCounted

static func eh_jogador(body: Node) -> bool:
	if body == null:
		return false
	if body is Player:
		return true
	if body.is_in_group("jogador") or body.is_in_group("player"):
		return true
	var nome := body.name.to_lower()
	return nome == "jogador" or nome == "player"
