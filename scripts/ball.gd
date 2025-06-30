extends CharacterBody2D

const screen_top: float = 200
const screen_bottom: float = 600
const screen_left: float = 0
const screen_right: float = 400

const max_opening_angle: float = 60
const min_opening_angle: float = 30

@export var max_speed: float = 400
@export var initial_speed: float = 300
@export var acceleration: float = 500
@export var elasticity_coeff: float = 0.6
@export var momentum_transfer_factor: float = 0.4

var speed: float = initial_speed
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	reposition()


func _physics_process(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(direction * speed * delta)
	if collision:
		position += collision.get_remainder()
		var collider = collision.get_collider()
		if collider.is_in_group("paddle"):
			var paddle_velocity: Vector2 = collider.velocity
			var normal: Vector2 = collision.get_normal()
			var new_vel: Vector2 = calculate_new_velocity(direction * speed, paddle_velocity, normal)
			direction = new_vel.normalized()
			speed = min(new_vel.length(), max_speed)
		else:
			direction = direction.bounce(collision.get_normal())


func calculate_new_velocity(ball_velocity: Vector2, paddle_velocity: Vector2, normal: Vector2):
	var v_pb_n: float = (ball_velocity - paddle_velocity).dot(normal)
	
	if v_pb_n > 0:
		return ball_velocity
	
	var impulse: float = (1 + elasticity_coeff + (0.001) * paddle_velocity.length()) * v_pb_n
	var new_velocity: Vector2 = ball_velocity - impulse * normal
	new_velocity += paddle_velocity * momentum_transfer_factor
	
	return new_velocity

func reposition() -> void:
	# set the position
	position.x = (screen_left + screen_right) / 2
	position.y = (screen_top + screen_bottom) / 2
	
	set_direction()
	reset_speed()

func set_direction() -> void:
	# get the angle in first quadrant
	var angle: float = randf_range(min_opening_angle, max_opening_angle)
	
	var option: int = randi_range(1, 4)
	match option:
		1: # first quadrant
			pass
		2: # second quadrant
			angle = 180 - angle
		3: # third quadrant
			angle = 180 + angle
		4: # fourth quadrant
			angle = -angle
	
	direction = Vector2(cos(deg_to_rad(angle)), sin(deg_to_rad(angle)))

func reset_speed() -> void:
	speed = initial_speed

func stop() -> void:
	direction = Vector2.ZERO
	speed = 0
