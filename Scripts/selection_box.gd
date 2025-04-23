extends Control

var mouse_position = Vector2()
var start_selection_position = Vector2()
const selection_box_color = Color(0, 1, 0)
const selection_box_line_width = 3

func _ready():
	anchor_left = 0
	anchor_top = 0
	anchor_right = 1
	anchor_bottom = 1

func _draw():
	if self.visible and start_selection_position != mouse_position:
		var top_left = start_selection_position
		var top_right = Vector2(mouse_position.x, start_selection_position.y)
		var bottom_right = mouse_position
		var bottom_left = Vector2(start_selection_position.x, mouse_position.y)

		var points = PackedVector2Array([top_left, top_right, bottom_right, bottom_left, top_left])
		draw_polyline(points, selection_box_color, selection_box_line_width)

func _process(_delta):
	queue_redraw()
