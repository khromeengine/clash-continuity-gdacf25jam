class_name GameStateBoundEntity
extends CharacterBody2D


func _ready():
	GameStateManager.tick_game_logic_frame.connect(tick_frame)


func tick_frame(_delta: float):
	pass
