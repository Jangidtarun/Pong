extends Control

signal restart_game
@onready var winner_message: Label = $VBoxContainer/MessagePanel/VBoxContainer/WinnerMessage

func _on_button_button_up() -> void:
	print("emitted restart signal")
	restart_game.emit()

func set_message(message: String) -> void:
	winner_message.text = message
