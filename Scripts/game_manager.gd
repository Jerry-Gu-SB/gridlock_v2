extends Node3D

signal player_loss
signal player_win
signal third_option

var unit_count = 0
var heart_count = 5
var easter_egg = 0
var stop_checking = false

@onready var world_scene = $World
@onready var ui_scene = $"User Interface"

func _ready() -> void:
	GlobalTimer.start_timer(3.0)
	GlobalTimer.timer_expired.connect(_on_timer_expired)

func _process(_delta: float) -> void:
	var current_units = get_tree().get_nodes_in_group("units")
	if current_units.size() != unit_count:
		unit_count = current_units.size()
		print("Unit count updated:", unit_count)

func _on_timer_expired() -> void:
	var current_units = get_tree().get_nodes_in_group("units")
	unit_count = current_units.size()
	
	if unit_count >= 10:
		heart_count -= 1
		print("Heart lost! Remaining:", heart_count)
	
	if 1 < unit_count and unit_count <= 5:
		easter_egg += 1
	
	if heart_count <= 0:
		stop_checking = true
		world_scene.visible = false
		emit_signal("player_win")
		heart_count = 5
		
	if easter_egg >= 10:
		stop_checking = true
		world_scene.visible = false
		emit_signal("third_option")
		easter_egg = 0
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	if not stop_checking and unit_count == 0:
		world_scene.visible = false
		emit_signal("player_loss")
	
func _on_user_interface_restart_game() -> void:
	get_tree().reload_current_scene()
	stop_checking = false
	GlobalTimer.start_timer(3.0)
