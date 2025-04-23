extends Control

@onready var timer_label = $"UI Timer"
@onready var player_loss_scene = $"PlayerLoss"

signal restart_game

var show_timer = true

func _ready():
	GlobalTimer.timer_updated.connect(_on_timer_updated)
	timer_label.hide()
	player_loss_scene.hide()

func _on_timer_updated(time_left: float):
	timer_label.text = "Time: %.2f" % time_left
	if not timer_label.visible and show_timer:
		timer_label.show()

func _on_root_player_loss() -> void:
	timer_label.hide()
	player_loss_scene.show()

func _on_player_loss_retry_requested() -> void:
	player_loss_scene.hide()
	emit_signal("restart_game")
	show_timer = true
