extends CharacterBody2D

func _ready() -> void:
	add_to_group("jogador")
	add_to_group("player")

# Variaveis de movimentação
var direcao
var velocidade : float = 150.0
var forcaPulo : float = -150.0
var gravidade = ProjectSettings.get_setting("physics/2d/default_gravity") 
var pulando : bool = false
var tempoPulo : float = 0.25
var cronometroPulo : float = 0
var tempoFlutuando : float = 0.075
var cronometroFlutuando : float = 0
var controlavel : bool = true
var invulneravel : bool = false
var recebendo_dano : bool = false

# Variaveis da vida do personagem
@export var vida_maxima: int = 3
@onready var vida_atual: int = vida_maxima

# Variavel com o local do node que comtem animações do personagem
@onready var animacao = $AnimatedSprite2D

# ----- Bloco pulo - governa todas as funções referente ao pulo do jogador -----
func pulo(atualizacao) -> void:
	# Todas os "if" dessa função requerem que o jogador seja controlavel
	
	# Aplica a força do pulo se o botão de pulo for precionado, e o personagem esteja ou no chao ou em "Coiote time"
	if Input.is_action_just_pressed("pulo") and (is_on_floor() or cronometroFlutuando < tempoFlutuando) and controlavel:
		velocity.y = forcaPulo
		pulando = true
	
	# Incrementa a força do pulo caso o jogador segure o potão de pulo
	elif Input.is_action_pressed("pulo") and pulando and controlavel:
		velocity.y = forcaPulo-80
	
	# Nega o incremento do pulo pela função acima
	if pulando and Input.is_action_pressed("pulo") and cronometroPulo < tempoPulo and controlavel:
		cronometroPulo += atualizacao
	else:
		pulando = false
		cronometroPulo = 0
# ----- Bloco pulo - governa todas as funções referente ao pulo do jogador -----

# ----- Bloco _physics_process - Atualia a todo frame -----
func _physics_process(delta):
	if not controlavel:
		return
	
	# Aplicando a gravidade, mas apenas se o personagem não estiver pulando
	if not is_on_floor() and not pulando:
		velocity.y += gravidade * delta
		cronometroFlutuando += delta
	else:
		cronometroFlutuando = 0
	
	# Chama a função pulo
	pulo(delta)
	
	# Se o jogador precionar para baixo em contato ao chao ele desse 1 pixel (desse plataformas de sentido unico)
	if Input.is_action_just_pressed("baixo") and is_on_floor() and controlavel:
		position.y += 1
	
	# Utiliza a variavel "direcao" para aplicar a movimentação horizontal ao personagem
	direcao = Input.get_axis("irEsquerda", "irDireita")
	if direcao and controlavel:
		velocity.x = direcao * velocidade
	else:
		velocity.x = move_toward(velocity.x, 0, velocidade)
	
	move_and_slide()
	update_animations()
# ----- Bloco _physics_process - Atualia a todo frame -----

# Função para atualizar a animação com base na direção em que o jogador está indo
func update_animations():
	if recebendo_dano or not controlavel:
		return

	if direcao != 0:
		animacao.flip_h = direcao < 0
		animacao.play("correndo")	
	else:
		animacao.play("ancioso")
		
	if not is_on_floor() and pulando:
		animacao.play("pulando") 
	elif not is_on_floor() and not pulando:
		animacao.play("caindo") 

# Função que causa dano ao personagem
func perder_vida(quantidade: int) -> void:
	if invulneravel or not controlavel:
		return

	invulneravel = true
	vida_atual -= quantidade
	print("Jogador perdeu vida! Vida atual: ", vida_atual)
	if vida_atual <= 0:
		vida_atual = 0
		morto()
	else:
		recebendo_dano = true
		animacao.play("hurt")
		await get_tree().create_timer(0.4).timeout
		if not is_inside_tree():
			return
		recebendo_dano = false
		invulneravel = false

# Função que recupera a vida do personagem
func ganhar_vida(quantidade: int) -> void:
	vida_atual += quantidade
	print("Jogador ganhou vida! Vida atual: ", vida_atual)

func rebater_ao_pisar() -> void:
	velocity.y = forcaPulo
	pulando = true
	cronometroPulo = 0
	cronometroFlutuando = 0

# Função que "mata" o personagem (tira o controle e deixa o personagem invisivel)
func morto() -> void:
	controlavel = false
	invulneravel = true
	animacao.play("die")
	await get_tree().create_timer(1).timeout
	if not is_inside_tree():
		return
	visible = false
	resetar()

# Função que revive o personagem e recarega a fase
func resetar() -> void:
	vida_atual = vida_maxima
	controladorFases.carregarFase(controladorFases.idFaseAtual)
	visible = true
	controlavel = true
