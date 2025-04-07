extends Node

signal timer_expired
signal timer_updated(time_left: float)

@onready var timer := $Timer

func _ready():
	timer.timeout.connect(_on_timer_timeout)

func start_timer(duration: float):
	timer.wait_time = duration
	timer.start()

func _on_timer_timeout():
	timer_expired.emit()

func _process(_delta):
	if timer.is_stopped():
		return
	timer_updated.emit(timer.time_left)
