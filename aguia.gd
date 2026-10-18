extends "res://scripts/inimigo.gd"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var velocidade: float = 60.0

var direcao: int = -1

func _physics_process(delta: float) -> void:
	# Movimenta para esquerda/direita
	position.x += direcao * velocidade * delta

func _on_timer_timeout() -> void:
	direcao *= -1
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
