extends Control

var mouse_position = Vector2()
var start_selection_position = Vector2()
const selection_box_color = Color(0, 1, 0)
const selection_box_line_width = 3

func _draw():
	if self.visible and start_selection_position != mouse_position:
		draw_line(start_selection_position, Vector2(mouse_position.x, start_selection_position.y), selection_box_color, selection_box_line_width)
		draw_line(start_selection_position, Vector2(start_selection_position.x, mouse_position.y), selection_box_color, selection_box_line_width)
		draw_line(mouse_position, Vector2(mouse_position.x, start_selection_position.y), selection_box_color, selection_box_line_width)
		draw_line(mouse_position, Vector2(start_selection_position.x, mouse_position.y), selection_box_color, selection_box_line_width)

func _process(_delta):
	queue_redraw()
