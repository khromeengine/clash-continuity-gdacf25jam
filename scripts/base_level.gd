extends Node2D


@export var camera: Camera2D
@export var animation_player: AnimationPlayer


func _ready():
	activate_level()


func activate_level():
	GameStateManager.level = self
	GameStateManager.game_start.emit()
	GameStateManager.level_camera = camera
	animation_player.play("show")


func reset_level():
	pass
