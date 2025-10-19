class_name Controller
extends Node2D


enum Heading {
	LEFT,
	RIGHT,
}

@export var los_raycast: RayCast2D
@export var patrol_range: float = 200
@export var preferred_combat_range: float = 180
@export var combat_zone: float = 20

@export var scan_zone: Area2D
@export var lost_timer: Timer
@export var lost_time: float = 2.0

var target: ControlledEntity = null
var looking_at_position: Vector2 = Vector2.ZERO
var patrol_left_x: float
var patrol_right_x: float
var is_heading: Heading = Heading.LEFT:
	set(dir):
		if dir == Heading.LEFT:
			scale.x = abs(scale.x) * -1
		else:
			scale.x = abs(scale.x)
		is_heading = dir


var possible_targets: Array[ControlledEntity]


func _ready():
	patrol_left_x = global_position.x - patrol_range
	patrol_right_x = global_position.x + patrol_range
	scan_zone.area_entered.connect(_on_body_entered_scan_zone)
	scan_zone.area_exited.connect(_on_body_exited_scan_zone)
	GameStateManager.tick_game_logic_frame.connect(tick_frame)


func tick_frame(_delta: float):
	scan_los()
	if target and los_raycast.get_collider() and target.is_ancestor_of(los_raycast.get_collider()):
		looking_at_position = target.global_position
	if target and los_raycast.get_collider() and not target.is_ancestor_of(los_raycast.get_collider()):
		lost_timer.start(lost_time)


func scan_los():
	if target and target in possible_targets:
		los_raycast.target_position = to_local(target.global_position)
		for check in possible_targets:
			if check.global_position.distance_to(global_position) < target.global_position.distance_to(global_position):
				target = check
				return
	else:
		for check in possible_targets:
			los_raycast.target_position = to_local(check.global_position)
			#print(los_raycast.target_position)
			if los_raycast.get_collider() and check.is_ancestor_of(los_raycast.get_collider()):
				target = check
				return


func ask_for_target_location():
	return target


func ask_input(ready_to_fire: bool):
	var list_input: Array[ControlCentral.PossibleInputs] = []
	if target != null and los_raycast.is_colliding() and target.is_ancestor_of(los_raycast.get_collider()):
		if ready_to_fire:
			list_input.push_back(ControlCentral.PossibleInputs.RELEASE_FIRE)
		else:
			list_input.push_back(ControlCentral.PossibleInputs.FIRE)
		var x_dist = looking_at_position.x - global_position.x
		if x_dist >= 0:
			if x_dist >= preferred_combat_range + combat_zone:
				list_input.push_back(ControlCentral.PossibleInputs.M_RIGHT)
			elif x_dist <= preferred_combat_range - combat_zone:
				list_input.push_back(ControlCentral.PossibleInputs.M_LEFT)
		elif x_dist < 0:
			if x_dist <= -preferred_combat_range - combat_zone:
				list_input.push_back(ControlCentral.PossibleInputs.M_LEFT)
			elif x_dist >= -preferred_combat_range + combat_zone:
				list_input.push_back(ControlCentral.PossibleInputs.M_RIGHT)
	else:
		# patrol
		if is_heading == Heading.LEFT:
			if global_position.x < patrol_left_x:
				is_heading = Heading.RIGHT
				list_input.push_back(ControlCentral.PossibleInputs.M_RIGHT)
			else:
				list_input.push_back(ControlCentral.PossibleInputs.M_LEFT)
		else:
			if global_position.x > patrol_right_x:
				is_heading = Heading.LEFT
				list_input.push_back(ControlCentral.PossibleInputs.M_LEFT)
			else:
				list_input.push_back(ControlCentral.PossibleInputs.M_RIGHT)
	return list_input


func _on_body_entered_scan_zone(body: Area2D):
	if body.get_parent() is ControlledEntity and not body.get_parent().is_ancestor_of(self):
		possible_targets.push_back(body.get_parent())


func _on_body_exited_scan_zone(body: Area2D):
	if body.get_parent() is ControlledEntity and not body.get_parent().is_ancestor_of(self):
		possible_targets.erase(body.get_parent())
