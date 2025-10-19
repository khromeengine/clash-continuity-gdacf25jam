class_name LaserSightCross
extends Node2D

@export var left_arm: Node2D
@export var right_arm: Node2D
@export var center_sight: Sprite2D
@export var left_laser: Sprite2D
@export var right_laser: Sprite2D


var progress: float = 0.0
var left_default_angle: float = deg_to_rad(-45.0)
var right_default_angle: float = deg_to_rad(45.0)


func _ready():
	focus(0.2)


func focus(progress: float):
	left_arm.rotation = lerp_angle(left_default_angle, 0, 1 - pow(1 - progress, 2))
	right_arm.rotation = lerp_angle(right_default_angle, 0, 1 - pow(1 - progress, 2))
	center_sight.set_instance_shader_parameter("opacity", progress)


func fire_reset():
	center_sight.set_instance_shader_parameter("warbling", false)
	left_laser.set_instance_shader_parameter("warbling", false)
	right_laser.set_instance_shader_parameter("warbling", false)
	center_sight.set_instance_shader_parameter("opacity", 0)
	


func start_warbling():
	center_sight.set_instance_shader_parameter("warbling", true)
	left_laser.set_instance_shader_parameter("warbling", true)
	right_laser.set_instance_shader_parameter("warbling", true)
