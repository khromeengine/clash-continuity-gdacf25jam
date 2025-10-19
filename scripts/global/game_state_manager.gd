extends Node

signal tick_game_logic_frame(delta: float)
signal request_paused_game
signal succeeded_paused_game
signal request_unpaused_game
signal succeeded_unpaused_game
signal request_slowed_game
signal succeeded_slowed_game
signal request_normal_game
signal succeeded_normal_game

signal game_start
signal player_die
signal game_restart

enum GameState {
	PAUSED,
	RUNNING,
	SLOWED,
}


@export var state: GameState = GameState.RUNNING:
	set(new_state):
		state = new_state
		update_state_info()
	get():
		return state
var slowed_speed: float = 0.1
var controlled_player: ControlledEntity
var unpaused_state: GameState

var level: Node2D

var level_camera: Camera2D
var camera_override: Camera2D:
	set(cam):
		camera_override = cam
		if cam:
			level_camera.enabled = false
		else:
			level_camera.enabled = true


func _ready():
	request_slowed_game.connect(on_request_slowed_speed)
	request_normal_game.connect(on_request_normal_speed)
	request_paused_game.connect(on_request_paused_game)
	request_unpaused_game.connect(on_request_unpaused_game)


func _physics_process(delta: float) -> void:
	match(state):
		GameState.PAUSED:
			pass
		_:
			tick_frame(delta)


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


func set_slowed_speed(multi: float):
	Engine.time_scale = clampf(multi, 0, 1)


func update_state_info():
	match(state):
		GameState.RUNNING:
			Engine.time_scale = 1.0
		GameState.SLOWED:
			Engine.time_scale = slowed_speed
		_:
			Engine.time_scale = 0.0


func on_request_slowed_speed():
	state = GameState.SLOWED
	succeeded_slowed_game.emit()


func on_request_normal_speed():
	state = GameState.RUNNING
	succeeded_normal_game.emit()


func on_request_paused_game():
	unpaused_state = state
	state = GameState.PAUSED
	succeeded_paused_game.emit()


func on_request_unpaused_game():
	state = unpaused_state
	succeeded_unpaused_game.emit()


func override_camera(camera: Camera2D):
	level_camera.enabled = false
	camera_override = camera
	camera.enabled = true


func stop_override_camera():
	camera_override.enabled = false
	level_camera.enabled = true
