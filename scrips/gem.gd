extends CollectibleItem
class_name Gem

signal diamante_coletado(pontos: int)

var coletado: bool = false

func _ready() -> void:
	super._ready()
	add_to_group("diamantes")
	add_to_group("coletaveis")

func _on_body_entered(body: Node2D) -> void:
	if coletado:
		return
	if JogadorCompat.eh_jogador(body):
		coletado = true
		diamante_coletado.emit(score_value)
		_collect()

func _collect() -> void:
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	super._collect()
