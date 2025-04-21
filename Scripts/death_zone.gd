extends Area3D

var units_in_zone: Array = []

func _ready():
	GlobalTimer.timer_expired.connect(_on_global_timer_expired)
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("units"):
		if not units_in_zone.has(body):
			units_in_zone.append(body)
			body.set_highlighted_by_deathzone(true)

func _on_body_exited(body):
	if body.is_in_group("units"):
		units_in_zone.erase(body)
		body.set_highlighted_by_deathzone(false)

func _on_global_timer_expired():
	for unit in units_in_zone.duplicate():
		unit.queue_free()
	units_in_zone.clear()
