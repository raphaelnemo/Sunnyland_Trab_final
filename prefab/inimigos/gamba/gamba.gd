extends "res://scripts/inimigo.gd"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var player: CharacterBody2D
# Tempo (s) até o gamba inverter a direção; define o tamanho do percurso (velocidade * tempo)
@export var tempoPatrulha : float = 2.5

const velocidade = 40.0
var direcao := -1

func _ready() -> void:
	$Timer.start(tempoPatrulha)

func _physics_process(delta):
	position.x += direcao * velocidade * delta

func _on_timer_timeout() -> void:
	direcao *= -1
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
