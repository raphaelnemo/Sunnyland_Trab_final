extends CollectibleItem
class_name Cherry

signal jogador_recuperacao(body: Node2D)

var coletado: bool = false

func _ready() -> void:
	super._ready()
	add_to_group("coletaveis")

func _on_body_entered(body: Node2D) -> void:
	if coletado:
		return
	if JogadorCompat.eh_jogador(body):
		coletado = true
		jogador_recuperacao.emit(body)
		_collect()
