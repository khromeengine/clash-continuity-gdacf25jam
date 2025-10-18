class_name ControlledEntity
extends GameStateBoundEntity


@export_group("Entity Info")
@export var player_override: bool = false

@export_group("Movement")
@export var move_accel: float = 200
@export var max_speed: float = 500
@export var gravity: float = 3000
@export var friction: float = 0.2
@export var terminal_velocity: float = 1500
@export var sharp_turn_multiplier: float = 0.2
@export var air_move_multiplier: float = 0.2
@export var jump_speed: float = 700



var stunned: bool = false
var moving: bool = false
var weapon: Variant
var controller: Variant


func _ready():
	super()


func tick_frame(delta: float):
	if not stunned:
		parse_controller_input(delta)
	move_and_slide()
	apply_gravity(delta)
	apply_friction(delta)


func parse_controller_input(delta: float):
	moving = false
	var list_inputs = ControlCentral.get_last_player_inputs() if player_override else [] ##
	for input in list_inputs:
		match(input):
			ControlCentral.PossibleInputs.M_LEFT:
				moving = true
				move_left(delta)
			ControlCentral.PossibleInputs.M_RIGHT:
				moving = true
				move_right(delta)
			ControlCentral.PossibleInputs.JUMP:
				try_jump()
			ControlCentral.PossibleInputs.FIRE:
				fire_weapon(delta)
			ControlCentral.PossibleInputs.RELEASE_FIRE:
				release_weapon(delta)


func apply_gravity(delta: float):
	print(velocity.y)
	if not is_on_floor():
		velocity.y = clampf(velocity.y + (gravity * delta), -INF, terminal_velocity)



func apply_friction(delta: float):
	if is_on_floor() and not moving:
		velocity.x = lerpf(velocity.x, 0, 1 - pow(friction, 10 * delta))


func move_left(delta: float):
	if not is_on_floor():
		velocity.x = clampf(velocity.x - move_accel * air_move_multiplier, -max_speed, INF)
		return
	if velocity.x > 0:
		velocity.x = sharp_turn_multiplier * velocity.x
	if velocity.x > -max_speed:
		velocity.x = clampf(velocity.x - move_accel, -max_speed, INF)


func move_right(delta: float):
	if not is_on_floor():
		velocity.x = clampf(velocity.x + move_accel * air_move_multiplier, -INF, max_speed)
		return
	if velocity.x < 0:
		velocity.x = sharp_turn_multiplier * velocity.x
	if velocity.x < max_speed:
		velocity.x = clampf(velocity.x + move_accel, -INF, max_speed)


func try_jump():
	if not is_on_floor():
		return
	velocity.y = -jump_speed


func fire_weapon(delta: float):
	return
	weapon.fire()


func release_weapon(delta: float):
	return
	weapon.release()
