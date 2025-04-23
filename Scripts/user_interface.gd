extends Control

@onready var timer_label = $"UI Timer"
@onready var player_loss_scene = $"PlayerLoss"
@onready var player_win_scene = $"PlayerWin"
@onready var third_option_scene = $"ThirdOptionWin"

signal restart_game

var show_timer = true

func _ready():
	GlobalTimer.timer_updated.connect(_on_timer_updated)
	timer_label.hide()
	player_loss_scene.hide()
	player_win_scene.hide()

func _on_timer_updated(time_left: float):
	timer_label.text = "Time: %.2f" % time_left
	if not timer_label.visible and show_timer:
		timer_label.show()

func _on_root_player_loss() -> void:
	timer_label.hide()
	show_timer = false
	player_loss_scene.show()
	
func _on_root_player_win() -> void:
	timer_label.hide()
	show_timer = false
	player_win_scene.show()

func _on_root_third_option() -> void:
	timer_label.hide()
	show_timer = false
	third_option_scene.show()
	
func _on_player_loss_retry_requested() -> void:
	player_loss_scene.hide()
	emit_signal("restart_game")
	show_timer = true

func _on_player_win_retry_requested() -> void:
	player_win_scene.hide()
	emit_signal("restart_game")
	show_timer = true


func _on_third_option_win_retry_requested() -> void:
	third_option_scene.hide()
	emit_signal("restart_game")
	show_timer = true
