class_name laser_sight_cross
extends Node2D

@export var left_arm: Node2D
@export var right_arm: Node2D

var progress: float = 0.0
var left_default_angle: float = deg_to_rad(-45.0)
var right_default_angle: float = deg_to_rad(45.0)


func _ready():
	focus(1)


func focus(progress: float):
	left_arm.rotation = lerp_angle(left_default_angle, 0, 1 - pow(1 - progress, 2))
	right_arm.rotation = lerp_angle(right_default_angle, 0, 1 - pow(1 - progress, 2))

func reset():
	pass
