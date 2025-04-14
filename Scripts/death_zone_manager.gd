extends Node3D

@export var death_zone_scene: PackedScene
@export var spawn_origin: Vector3 = Vector3.ZERO
@export var spacing: float = 3.0

var active_zones: Array[Node3D] = []
var pattern_index := 0
var patterns = ["checkmark", "x", "zigzag"]

func _ready():
	GlobalTimer.timer_expired.connect(_on_timer_expired)

func _on_timer_expired():
	# 1. Let zones do their killing first
	await get_tree().process_frame  # ensures _on_global_timer_expired runs in DeathZone

	# 2. Clean up all existing zones
	for zone in active_zones:
		if zone:
			zone.queue_free()
	active_zones.clear()

	# 3. Move to next pattern
	pattern_index = (pattern_index + 1) % patterns.size()
	var new_positions = get_pattern_positions(patterns[pattern_index])

	# 4. Spawn new zones in the next pattern
	for pos in new_positions:
		var zone = death_zone_scene.instantiate()
		zone.global_transform.origin = spawn_origin + pos * spacing
		get_tree().current_scene.add_child(zone)
		active_zones.append(zone)
		
func get_pattern_positions(pattern: String) -> Array[Vector3]:
	match pattern:
		"checkmark":
			return [Vector3(0, 0, 0), Vector3(1, 0, 1), Vector3(2, 0, 2), Vector3(3, 0, 1), Vector3(4, 0, 0)]
		"x":
			return [Vector3(0, 0, 0), Vector3(1, 0, 1), Vector3(2, 0, 2), Vector3(0, 0, 2), Vector3(2, 0, 0)]
		"zigzag":
			return [Vector3(0, 0, 0), Vector3(1, 0, 1), Vector3(2, 0, 0), Vector3(3, 0, 1), Vector3(4, 0, 0)]
		_:
			return []
