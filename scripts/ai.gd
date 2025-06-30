extends "res://scripts/paddle.gd"

@onready var ball: CharacterBody2D = $"../Ball"

var min_chase_dist: float = 10

func _physics_process(delta: float) -> void:
	position.y = screen_top + 1.5 * paddle_height
	
	var target: float = ball.position.x
	direction = sign(target - position.x)
	var distance: float = abs(target - position.x)
	var speed: float = max_speed
	
	if distance < min_chase_dist or ball.direction.y > 0 or ball.position.y < screen_top:
		direction = 0
	
	move(speed, delta)
