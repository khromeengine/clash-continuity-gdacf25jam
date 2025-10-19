class_name Weapon
extends Node2D


var target: Node2D
var target_rotation: float
var rotation_weight: float


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


func fire():
	pass


func release():
	pass
