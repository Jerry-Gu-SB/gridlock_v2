extends Control

@onready var timer_label = $"UI Timer"

func _ready():
	GlobalTimer.timer_updated.connect(_on_timer_updated)
	GlobalTimer.timer_expired.connect(_on_timer_expired)

func _on_timer_updated(time_left: float):
	timer_label.text = "Time: %.2f" % time_left

func _on_timer_expired():
	timer_label.text = "Boom! Done!"
