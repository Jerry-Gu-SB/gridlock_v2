extends Node3D

signal player_loss

var unit_count = 0

@onready var world_scene = $World
@onready var ui_scene = $"User Interface"  # Reference the UI scene node

func _ready() -> void:
	GlobalTimer.start_timer(3.0)

func _process(_delta: float) -> void:
	var current_units = get_tree().get_nodes_in_group("units")
	if current_units.size() != unit_count:
		unit_count = current_units.size()
		print("Unit count updated:", unit_count)
	
	if get_tree().get_nodes_in_group("units").is_empty():
		world_scene.visible = false
		emit_signal("player_loss")

# Example of sending a win signal if you wanted that too
# If there’s a condition where you win the game, you can use:
# emit_signal("game_over", "win")


func _on_user_interface_restart_game() -> void:
	get_tree().reload_current_scene()
	GlobalTimer.start_timer(3.0)
