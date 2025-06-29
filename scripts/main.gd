extends Node2D

var player_score: int = 0
var ai_score: int = 0
var game_round: int = 1
var last_game_round: int = 1
var max_round: int = 12


@onready var ball: CharacterBody2D = $Ball
@onready var ai: CharacterBody2D = $AI
@onready var player: CharacterBody2D = $Player
@onready var player_score_label: Label = $UI/ScoreBox/PlayerScore
@onready var ai_score_label: Label = $UI/ScoreBox/AIScore
@onready var game_round_label: Label = $UI/Round
@onready var game_over_screen: Control = $UI/GameOverScreen


func _on_player_score_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		player_score += 1
		print("Player: ", str(player_score))
		# also update the ui text
		player_score_label.text = str(player_score)
		next_round()


func _on_ai_score_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		ai_score += 1
		print("AI: ", str(ai_score))
		# also update the ui text
		ai_score_label.text = str(ai_score)
		next_round()


func next_round() -> void:
	game_round += 1
	
	if game_round > max_round:
		game_over()
	
	game_round_label.text = "Round: " + str(game_round)
	
	# reposition the ball and paddles
	ball.reposition()
	#player.reposition()
	ai.reposition()
	
	if game_round - last_game_round >= 5:
		ai.reduce_aim_randomness()
		last_game_round = game_round

func _on_restart_button_button_up() -> void:
	# restart the game
	game_round = 1
	player_score = 0
	ai_score = 0
	
	game_round_label.text = "Round: " + str(game_round)
	player_score_label.text = str(player_score)
	ai_score_label.text = str(ai_score)

	game_over_screen.hide()
	get_tree().paused = false
	
	ball.reposition()
	ai.reposition()
	

func game_over() -> void:
	get_tree().paused = true
	game_over_screen.show()
