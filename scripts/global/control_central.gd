extends Controller

enum PossibleInputs {
	M_LEFT,
	M_RIGHT,
	JUMP,
	FIRE,
	RELEASE_FIRE,
	SHIFT,
	PAUSE,
}


var _list_inputs: Array[PossibleInputs]


func _physics_process(delta: float) -> void:
	parse_last_player_inputs()
	print(_list_inputs)


func parse_last_player_inputs():
	_list_inputs.clear()
	var leftright = Input.get_action_strength("right") - Input.get_action_strength("left")
	if leftright < 0:
		_list_inputs.push_back(PossibleInputs.M_LEFT)
	elif leftright > 0:
		_list_inputs.push_back(PossibleInputs.M_RIGHT)
	if Input.is_action_pressed("jump"):
		_list_inputs.push_back(PossibleInputs.JUMP)
	if Input.is_action_pressed("fire"):
		_list_inputs.push_back(PossibleInputs.FIRE)
	if Input.is_action_just_released("fire"):
		_list_inputs.push_back(PossibleInputs.RELEASE_FIRE)
	if Input.is_action_just_pressed("shift"):
		_list_inputs.push_back(PossibleInputs.SHIFT)


func parse_system_inputs():
	pass



func get_last_player_inputs():
	return _list_inputs
	
