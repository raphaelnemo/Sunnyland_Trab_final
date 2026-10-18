extends CanvasLayer
# Fundo (céu/mar + colinas) desenhado atrás do cenário, com parallax horizontal.
# As posições vêm da transformação real da câmera, então não dependem de ParallaxBackground.

# Quanto cada camada acompanha a câmera (0 = parada na tela, 1 = presa ao mundo)
@export var fatorCeu : float = 0.05
@export var fatorColinas : float = 0.3

@onready var ceu : Node2D = $Ceu
@onready var colinas : Node2D = $Colinas

# Posições de cada camada com a câmera na borda esquerda da fase
const origemCeu := Vector2(-256, 0)
const origemColinas := Vector2(-512, 70)

func _process(_delta: float) -> void:
	# canto superior esquerdo do que a câmera mostra, em coordenadas do mundo
	var topoEsquerdo : Vector2 = -get_viewport().get_canvas_transform().origin
	ceu.position = origemCeu + Vector2(-topoEsquerdo.x * fatorCeu, 0)
	colinas.position = origemColinas + Vector2(-topoEsquerdo.x * fatorColinas, 0)
