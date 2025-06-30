extends "res://scripts/paddle.gd"

func _physics_process(delta: float) -> void:
	direction = Input.get_axis("left", "right")
	move(max_speed, delta)
	position.y = screen_bottom - 1.5 * paddle_height
