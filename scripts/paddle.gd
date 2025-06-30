extends CharacterBody2D

const screen_top: float = 200
const screen_bottom: float = 600
const screen_left: float = 0
const screen_right: float = 400

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var max_speed: float = 400
@export var acceleration: float = 4000
@export var friction: float = 3000

var paddle_width: float = 0
var paddle_height: float = 0
var direction: float = 0

func _ready() -> void:
	var paddle_size = sprite_2d.get_rect().size * self.scale
	paddle_height = paddle_size.x
	paddle_width = paddle_size.y
	
	reposition()


func reposition() -> void:
	position.x = (screen_left + screen_right) / 2


func clamp_horizontal() -> void:
	var left_lim: float = screen_left + paddle_width / 2
	var right_lim: float = screen_right - paddle_width / 2
	position.x = clamp(position.x, left_lim, right_lim)


func move(speed: float, delta: float) -> void:
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	move_and_collide(velocity * delta)
	clamp_horizontal()
