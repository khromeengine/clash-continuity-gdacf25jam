class_name ControlledEntity
extends GameStateBoundEntity


@export_group("Entity Info")
@export var player_override: bool = false
@export var stunned: bool = false

@export_group("Movement")
@export var move_accel: float = 1400
@export var max_speed: float = 200
@export var sharp_turn_multiplier: float = 0.2
@export var air_move_multiplier: float = 0.5
@export var jump_speed: float = 600

@export_group("Dependencies")
@export var sprite: Sprite2D
@export var weapon: Weapon
@export var animation_player: AnimationPlayer
@export var controller: Controller

var moving: bool = false


var highlight_color: Color = GlobalColor.enemy:
	set(color):
		highlight_color = color
		update_color()


func _ready():
	if player_override == true:
		GameStateManager.controlled_player = self
		highlight_ally()
	else:
		update_color()
	GameStateManager.game_start.connect(init_game)
	super()


func init_game():
	animation_player.play("start")


func tick_frame(delta: float):
	if not stunned:
		parse_controller_input(delta)
		if player_override:
			aim_at_mouse()
		else:
			weapon.lock_on_target(controller.ask_for_target_location())
	super(delta)


func parse_controller_input(delta: float):
	moving = false
	var list_inputs = ControlCentral.get_last_player_inputs() if player_override else controller.ask_input(weapon.fire_ready)
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


func aim_at_mouse():
	if weapon != null:
		weapon.aim_at(ControlCentral.get_mouse_position())



func apply_friction(delta: float):
	if is_on_floor() and not moving:
		velocity.x = lerpf(velocity.x, 0, 1 - pow(friction, 10 * delta))


func move_left(delta: float):
	if not is_on_floor():
		velocity.x = clampf(velocity.x - move_accel * air_move_multiplier * delta, -max_speed, INF)
		return
	if velocity.x > 0:
		velocity.x = sharp_turn_multiplier * velocity.x
	if velocity.x > -max_speed:
		velocity.x = clampf(velocity.x - move_accel * delta, -max_speed, INF)


func move_right(delta: float):
	if not is_on_floor():
		velocity.x = clampf(velocity.x + move_accel * air_move_multiplier * delta, -INF, max_speed)
		return
	if velocity.x < 0:
		velocity.x = sharp_turn_multiplier * velocity.x
	if velocity.x < max_speed:
		velocity.x = clampf(velocity.x + move_accel * delta, -INF, max_speed)


func try_jump():
	if not is_on_floor():
		return
	velocity.y = -jump_speed


func fire_weapon(delta: float):
	weapon.fire(delta)


func release_weapon(delta: float):
	weapon.release(delta)


func enable_player_override():
	pass


func disable_player_override():
	pass


func highlight_ally():
	highlight_color = GlobalColor.ally


func highlight_enemy():
	highlight_color = GlobalColor.enemy


func update_color():
	if sprite:
		sprite.set_instance_shader_parameter("outline_color", highlight_color)
