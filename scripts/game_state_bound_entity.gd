class_name GameStateBoundEntity
extends CharacterBody2D

@export_group("Physics")
@export var gravity: float = 3000
@export var friction: float = 0.2
@export var terminal_velocity: float = 1500


func _ready():
	GameStateManager.tick_game_logic_frame.connect(tick_frame)


func tick_frame(delta: float):
	move_and_slide()
	apply_gravity(delta)
	apply_friction(delta)


func apply_gravity(delta: float):
	velocity.y = clampf(velocity.y + (gravity * delta), -INF, terminal_velocity)


func apply_friction(delta: float):
	if is_on_floor():
		velocity.x = lerpf(velocity.x, 0, 1 - pow(friction, 10 * delta))
