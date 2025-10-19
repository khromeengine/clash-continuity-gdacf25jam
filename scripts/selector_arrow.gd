class_name SelectorArrow
extends GameStateBoundEntity


@export var move_speed: float = 200
@export var active: bool:
	set(is_enabled):
		active = is_enabled
		visible = is_enabled

@export var selected_body: ControlledEntity = null

var selected_body_queue: Array[ControlledEntity] = []

@onready var camera: Camera2D = $Camera2D
@onready var select_box: Area2D = $SelectorBox


func _ready():
	select_box.area_entered.connect(on_selector_box_enter)
	select_box.area_exited.connect(on_selector_box_leave)
	if selected_body != null:
		active = false


func _physics_process(delta: float):
	move_and_collide(velocity * delta / GameStateManager.get_game_speed())
	parse_selector_player_input(delta)


func parse_selector_player_input(delta: float):
	var list_inputs = ControlCentral.get_last_player_inputs()
	var dir = Vector2.ZERO
	for input in list_inputs:
		match(input):
			ControlCentral.PossibleInputs.M_UP:
				dir.y = 1
			ControlCentral.PossibleInputs.M_DOWN:
				dir.y = -1
			ControlCentral.PossibleInputs.M_LEFT:
				dir.x = -1
			ControlCentral.PossibleInputs.M_RIGHT:
				dir.x = 1
			ControlCentral.PossibleInputs.SHIFT:
				if not active:
					shift_from_target(selected_body)
				else:
					shift_to_target(selected_body)
			ControlCentral.PossibleInputs.FIRE:
				if active:
					shift_to_target(selected_body)
	if active:
		move_dir(dir)


func tick_frame(_delta: float):
	pass


func move_dir(direction: Vector2):
	velocity = direction.normalized() * move_speed
	update_selected_body()


func enable_shift():
	pass


func shift_from_target(body: ControlledEntity):
	if body.stunned:
		$FailSelectAudio.play()
		return
	selected_body_queue.clear()
	if selected_body != null:
		global_position = body.global_position
		body.player_override = false
	GameStateManager.request_slowed_game.emit()
	camera.enabled = true
	GameStateManager.camera_override = camera
	active = true
	$SelectAudio.play()
	update_selected_body()


func shift_to_target(body: ControlledEntity):
	if selected_body == null:
		if not $FailSelectAudio.playing:
			$FailSelectAudio.play()
		return
	body.player_override = true
	GameStateManager.request_normal_game.emit()
	camera.enabled = false
	GameStateManager.camera_override = null
	velocity = Vector2.ZERO
	active = false
	$SelectAudio.play()


func on_selector_box_enter(body: Area2D):
	if not active:
		return
	if body.get_parent() is ControlledEntity:
		selected_body_queue.push_back(body.get_parent())


func on_selector_box_leave(body: Area2D):
	if body.get_parent() is ControlledEntity and active:
		body.get_parent().highlight_enemy()
		selected_body_queue.erase(body.get_parent())


func update_selected_body():
	if selected_body_queue.is_empty():
		selected_body = null
		return
	if selected_body_queue.size() == 1:
		pass
	else:
		selected_body_queue.sort_custom(compare_distance)
	if selected_body != null:
		selected_body.highlight_enemy()
	selected_body = selected_body_queue.front()
	selected_body.highlight_ally()


func compare_distance(a: Node2D, b: Node2D):
	return true if a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position) else false
