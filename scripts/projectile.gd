class_name Projectile
extends GameStateBoundEntity


@export var hitbox: Area2D
@export var hitray: RayCast2D
@export var piercing: bool = false
@export var bounces: int

@export var trail: Line2D
@export var max_trail_length: float = 2000

@export var lifetime: float = 3.0
@export var lifetimer: Timer

@export var expiration_time: float = 0.1
@export var expiration_timer: Timer

@export var special_slow_multiplier: float = 0.1

var origin_point: Vector2 = Vector2.ZERO
var trail_length: float = 0

var deletion_process: bool = false


func _ready():
	lifetimer.timeout.connect(_on_life_timer_timeout)
	lifetimer.start(lifetime)
	expiration_timer.timeout.connect(_on_expiration_timer_timeout)
	hitbox.area_entered.connect(_on_hitbox_area_entered)
	trail.points[1] = global_position
	GameStateManager.succeeded_slowed_game.connect(_on_game_slow)
	GameStateManager.succeeded_normal_game.connect(_on_game_normal_speed)
	super()



func tick_frame(delta: float):
	hitray.target_position.x = velocity.length() * delta
	var collision = move_and_collide(velocity * delta)
	if collision:
		if bounces >= 1:
			velocity = velocity.bounce(collision.get_normal().normalized())
			trail.points[-1] = global_position
			trail.add_point(global_position)
			rotate_to_velocity()
			bounces -= 1
		else: 
			stop_projectile()
	if hitray.is_colliding():
		global_position += velocity.normalized() * hitray.get_collider().global_position.distance_to(global_position)
		_on_hitbox_area_entered(hitray.get_collider())
	if deletion_process:
		modulate.a = expiration_timer.time_left / expiration_time
		trail.modulate.a = expiration_timer.time_left / expiration_time
	else:
		calc_trail()
	

func init_projectile(velo: Vector2, origin: Vector2):
	if GameStateManager.state == GameStateManager.GameState.SLOWED:
		velocity = velo * special_slow_multiplier
	else:
		velocity = velo
	origin_point = origin
	global_position = origin
	trail.points[0] = origin
	rotate_to_velocity()


func rotate_to_velocity():
	rotation = velocity.angle()


func stop_projectile():
	if not deletion_process:
		velocity = Vector2.ZERO
		calc_trail()
		hitbox.set_deferred("monitoring", false)
		hitbox.set_deferred("monitorable", false)
		expiration_timer.start(expiration_time)
		deletion_process = true


func _on_hitbox_area_entered(body: Area2D):
	if not piercing:
		stop_projectile()


func _on_life_timer_timeout():
	stop_projectile()


func _on_expiration_timer_timeout():
	queue_free()


func calc_trail():
	trail.points[-1] = global_position


func _on_game_slow():
	velocity *= special_slow_multiplier

func _on_game_normal_speed():
	velocity /= special_slow_multiplier
