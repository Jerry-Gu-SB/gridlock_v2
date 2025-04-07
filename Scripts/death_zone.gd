extends Area3D

var detected_units: Array = []

func _ready():
	GlobalTimer.timer_expired.connect(_on_global_timer_expired)

func _on_global_timer_expired():
	detected_units.clear()

	for body in get_overlapping_bodies():
		if body.is_in_group("units"):
			detected_units.append(body)

	if detected_units.size() > 0:
		print(name, " hit units: ", detected_units.map(func(u): return u.name))
		_process_hits(detected_units)
	else:
		print(name, ": No units hit.")

func _process_hits(units: Array):
	for unit in units:
		unit.queue_free()
