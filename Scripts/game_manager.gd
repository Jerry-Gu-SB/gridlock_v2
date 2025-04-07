extends Node3D

@onready var timer = $"Global Timer/Timer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalTimer.start_timer(3.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
