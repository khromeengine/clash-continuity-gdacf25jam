class_name Weapon
extends Node2D

@export var cd: float = 1.0
@export var ready_threshold: float = 1.0
@export var laser_sights: LaserSightCross
@export var cdTimer: Timer
@export var animation_player: AnimationPlayer

var target: Node2D
var target_rotation: float
var rotation_weight: float

var firing_progress: float = 0.0


func _ready():
	GameStateManager.tick_game_logic_frame.connect(tick_frame)


func tick_frame(delta: float):
	if target != null:
		calc_target_rotation()
		rotate_towards_target(delta)


func rotate_towards_target(delta: float):
	rotation = lerp_angle(rotation, target_rotation, 1 - pow(rotation_weight, 10 * delta))


func aim_at(target_pos: Vector2):
	rotation = (target_pos - global_position).angle()


func calc_target_rotation():
	target_rotation = self.global_position.angle_to(target.global_position)


func lock_on_target(node: Node2D):
	target = node


func lock_off_target():
	target = null


func fire(delta: float):
	if cdTimer.is_stopped():
		firing_progress = clampf(firing_progress + delta, 0, ready_threshold)
		if firing_progress >= ready_threshold:
			laser_sights.start_warbling()
		laser_sights.focus(firing_progress / ready_threshold)


func release(delta: float):
	if firing_progress >= ready_threshold:
		cdTimer.start(cd)
		animation_player.play("recover", -1, 1 / cd)
		firing_progress = 0
	elif cdTimer.is_stopped():
		firing_progress = 0
		laser_sights.focus(firing_progress / ready_threshold)
	laser_sights.fire_reset()
