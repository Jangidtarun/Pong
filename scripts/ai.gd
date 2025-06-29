extends CharacterBody2D

@export var speed: float = 800
@export var acceleration: float = 2200
@export var friction: float = 3000

@onready var ball: CharacterBody2D = $"../Ball"
@onready var sprite_2d: Sprite2D = $Sprite2D

var screen_size: Vector2 = Vector2.ZERO
var sprite_region_rect_size: Vector2 = Vector2.ZERO
var paddle_width: float = 0
var paddle_height: float = 0
var move_up_limit: float = 0
var move_down_limit: float = 0
var aim_randomness: float = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	reposition()
	
	sprite_region_rect_size = sprite_2d.region_rect.size
	paddle_height = sprite_region_rect_size.y * sprite_2d.scale.y
	paddle_width = sprite_region_rect_size.x * sprite_2d.scale.x
	
	move_down_limit = screen_size.y - paddle_height
	move_up_limit = paddle_height

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_instance_valid(ball) or ball.global_position.x < 0:
		velocity.y = move_toward(velocity.y, 0, friction * delta)
		move_and_collide(velocity * delta)
		return
	
	var target: float = ball.global_position.y + randf_range(-aim_randomness, aim_randomness)
	var direction = sign(target - global_position.y)
	var distance = abs(target - global_position.y)
	
	if distance > 10:
		velocity.y = move_toward(velocity.y, direction * speed, acceleration * delta)
	else:
		velocity.y = move_toward(velocity.y, 0, friction * delta)

	move_and_collide(velocity * delta)
	global_position.y = clamp(global_position.y, move_up_limit, move_down_limit)
	global_position.x = 20


func reposition() -> void:
	position = Vector2(20, screen_size.y / 2)


func reduce_aim_randomness() -> void:
	aim_randomness *= 0.5
