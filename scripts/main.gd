extends Node2D

var player_score: int = 0
var ai_score: int = 0
var game_round: int = 1
var wait_time: float = 3
var do_not_update: bool = false

@export var max_game_rounds: int = 11

@onready var player_score_label: Label = $ScoreBoard/VBoxContainer/HBoxContainer/PlayerScorePanel/VBoxContainer2/PlayerScoreLabel
@onready var ai_score_label: Label = $ScoreBoard/VBoxContainer/HBoxContainer/AIScorePanel/VBoxContainer/AIScoreLabel
@onready var game_round_label: Label = $ScoreBoard/VBoxContainer/GameRoundPanel/GameRoundLabel
@onready var ai: CharacterBody2D = $AI
@onready var ball: CharacterBody2D = $Ball
@onready var timer: Timer = $Timer
@onready var game_over_screen: Control = $GameOverScreen


func _ready() -> void:
	restart_game()


func _on_player_score_detector_body_entered(_body: Node2D) -> void:
	if not do_not_update:
		player_score += 1
		set_player_score(player_score)
		next_round()


func _on_ai_score_detector_body_entered(_body: Node2D) -> void:
	if not do_not_update:
		ai_score += 1
		set_ai_score(ai_score)
		next_round()

func next_round() -> void:
	if not do_not_update:
		game_round += 1
		
		if game_round > max_game_rounds:
			game_over()
		else:
			set_game_round(game_round)
			timer.start(wait_time)
		ai.reposition()
		ball.reposition()
		ball.stop()

func set_game_round(_game_round: int) -> void:
	game_round_label.text = "Round " + str(int(_game_round))

func set_player_score(score: int) -> void:
	player_score_label.text = str(int(score))

func set_ai_score(score: int) -> void:
	ai_score_label.text = str(int(score))

func game_over() -> void:
	game_over_screen.show()
	ai.reposition()
	ball.reposition()
	do_not_update = true
	
	if player_score > ai_score:
		game_over_screen.set_message("You Won")
	elif player_score < ai_score:
		game_over_screen.set_message("Computer Won")
	else:
		game_over_screen.set_message("It's a Tie")

func _on_timer_timeout() -> void:
	ball.reposition()

func _on_game_over_screen_restart_game() -> void:
	restart_game()

func restart_game() -> void:
	reset_scores()
	reset_game_round()
	game_over_screen.hide()
	do_not_update = false
	ball.stop()
	timer.start(wait_time)

func reset_scores() -> void:
	player_score = 0
	set_player_score(player_score)
	
	ai_score = 0
	set_ai_score(ai_score)

func reset_game_round() -> void:
	game_round = 1
	set_game_round(game_round)
