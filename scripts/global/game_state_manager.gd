extends Node

signal tick_game_logic_frame(delta: float)
signal request_paused_game
signal succeeded_paused_game
signal request_slowed_game
signal succeeded_slowed_game(multiplier: float)


enum GameState {
	PAUSED,
	RUNNING,
	SLOWED,
}

@export var state: GameState = GameState.RUNNING
var slowed_speed: float = 0.5


func _physics_process(delta: float) -> void:
	match(state):
		GameState.RUNNING:
			Engine.time_scale = 1.0
			tick_frame(delta)
		GameState.SLOWED:
			Engine.time_scale = slowed_speed
			tick_frame(delta)
		_:
			pass


func tick_frame(delta: float):
	tick_game_logic_frame.emit(delta)


func get_game_speed():
	match(state):
		GameState.RUNNING:
			return 1.0
		GameState.SLOWED:
			return slowed_speed
		_:
			return 0.0


func set_game_speed():
	pass
