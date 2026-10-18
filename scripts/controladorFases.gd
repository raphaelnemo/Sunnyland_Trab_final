extends Node

var principal  : Node2D = null
var faseCarregada : fase = null
var idFaseAtual  : int = -1

func fecharfase() -> void : 
	if is_instance_valid(faseCarregada):
		faseCarregada.queue_free()
		
	faseCarregada = null

func carregarFase(idFase : int) -> void:
	print("Carregando: %s" % idFase)
	
	
	fecharfase()
	
	var dadofase = carregarDados(idFase)
	print(dadofase)
	
	if not dadofase:
		print("erro fase não esta no Array")
		return
	
	idFaseAtual = idFase
	var caminhoFase = "res://fases/%s/fase.tscn" % idFase
	var faseCaminho := load(caminhoFase)

	
	if faseCaminho:
		faseCarregada = faseCaminho.instantiate() as fase
		
		if is_instance_valid(faseCarregada):
			principal.add_child(faseCarregada)
		else:
			print("erro ao instanciar a fase")
	else:
		print("Fase não existe")

var fasesDisponiveis : Array[dadosFase]

func carregarDados(id : int) -> dadosFase:
	var faseRetornando : dadosFase = null
	
	for nivel : dadosFase in fasesDisponiveis:
		if nivel.idFase == id:
			faseRetornando = nivel
			
	return faseRetornando

func estaDesbloqueada(id : int) -> bool:
	for faseCarregada in fasesDisponiveis:
		if faseCarregada.idFase == id:
			return faseCarregada.faseDesbloqueada
	return false
	
func desbloquearFase(id : int) -> void:
	for faseCarregada in fasesDisponiveis:
		if faseCarregada.idFase == id && !estaDesbloqueada(id):
			faseCarregada.faseDesbloqueada = true

func estaCompletada(id : int) -> bool:
	for faseCarregada in fasesDisponiveis:
		if faseCarregada.idFase == id:
			return faseCarregada.faseCompletada
	return false

func faseCompletada(id : int) -> void:
	for faseCarregada in fasesDisponiveis:
		if faseCarregada.idFase == id && !estaCompletada(id):
			faseCarregada.faseCompletada = true
