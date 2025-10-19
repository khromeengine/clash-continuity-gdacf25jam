class_name ProjectileFactory
extends Node2D

@export var projectile_scene: PackedScene
@export var fire_speed: float = 500


func _ready() -> void:
	pass


func fire(at: Vector2):
	var proj = projectile_scene.instantiate() as Projectile
	proj.init_projectile(fire_speed * at.normalized(), global_position)
	GameStateManager.level.add_child(proj)
