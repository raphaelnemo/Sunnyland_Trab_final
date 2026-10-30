extends Area2D

func _ready() -> void:
	add_to_group("inimigos")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer
@export var player: CharacterBody2D

signal jogadorDano

const velocidade = 40.0
var direcao := -1
var derrotado := false

func _eh_jogador(body: Node2D) -> bool:
	if body == null:
		return false
	return body.is_in_group("jogador") or body.is_in_group("player") or body.name.to_lower() in ["jogador", "player"]

func _physics_process(delta):
	if derrotado:
		return
	position.x += direcao * velocidade * delta

func _on_timer_timeout() -> void:
	if derrotado:
		return
	direcao *= -1
	animated_sprite_2d.flip_h = not animated_sprite_2d.flip_h

func _on_body_entered(body: Node2D) -> void:
	if derrotado or not _eh_jogador(body):
		return

	if _esta_pisando(body):
		if body.has_method("rebater_ao_pisar"):
			body.rebater_ao_pisar()
		_derrotar()
	else:
		jogadorDano.emit(body)

func _esta_pisando(body: Node2D) -> bool:
	if not body is CharacterBody2D or body.velocity.y <= 0.0:
		return false

	var player_shape := body.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if not player_shape or not player_shape.shape or not collision_shape.shape:
		return false

	var player_bounds: Rect2 = player_shape.global_transform * player_shape.shape.get_rect()
	var enemy_bounds: Rect2 = collision_shape.global_transform * collision_shape.shape.get_rect()
	return player_bounds.end.y <= enemy_bounds.position.y + 6.0

func _derrotar() -> void:
	derrotado = true
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	collision_shape.set_deferred("disabled", true)
	timer.stop()

	var tween := create_tween().set_parallel(true)
	tween.tween_property(animated_sprite_2d, "scale", Vector2(1.25, 0.15), 0.25)
	tween.tween_property(animated_sprite_2d, "modulate:a", 0.0, 0.25)
	await tween.finished
	queue_free()
