extends CharacterBody2D


@onready var sprite_2d: Sprite2D = $Sprite2D

@export var max_speed: float = 1000
@export var acceleration: float = 4000
@export var friction: float = 3500

# calculated when game begins
var screen_size: Vector2 = Vector2.ZERO
var sprite_region_rect_size: Vector2 = Vector2.ZERO
var paddle_width: float = 0
var paddle_height: float = 0
var move_up_limit: float = 0
var move_down_limit: float = 0

func _ready() -> void:
	screen_size = get_viewport_rect().size
	reposition()
	
	sprite_region_rect_size = sprite_2d.region_rect.size
	paddle_height = sprite_region_rect_size.y * sprite_2d.scale.y
	paddle_width = sprite_region_rect_size.x * sprite_2d.scale.x
	
	move_down_limit = screen_size.y - paddle_height
	move_up_limit = paddle_height

func _physics_process(delta: float) -> void:
	var direction: float = Input.get_axis("up", "down")
	if direction:
		velocity.y = move_toward(velocity.y, direction * max_speed, acceleration * delta)
	else:
		velocity.y = move_toward(velocity.y, 0, friction * delta)
	
	move_and_collide(velocity * delta)
	global_position.y = clamp(global_position.y, move_up_limit, move_down_limit)
	global_position.x = screen_size.x - 20

	
	
func reposition() -> void:
	position = Vector2(screen_size.x - 20, screen_size.y / 2)
