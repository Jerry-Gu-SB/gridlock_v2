extends Node3D

const MOVE_MARGIN = 20
const MOVE_SPEED = 30
const RAY_LENGTH = 1000

var team = 0
var start_selection_position = Vector2()
var selected_units = []

@onready var camera = $Camera3D
@onready var selection_box = $SelectionBox

func _process(_delta: float) -> void:
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	#uncomment to enable camera scroll, and delete underscore from delta
	#calc_move(mouse_position, delta)
	if Input.is_action_just_pressed("main_command"):
		move_selected_units(mouse_position)
	if Input.is_action_just_pressed("alternate_command"):
		selection_box.start_selection_position = mouse_position
		start_selection_position = mouse_position
	if Input.is_action_pressed("alternate_command"):
		selection_box.mouse_position = mouse_position
		selection_box.visible = true
	else:
		selection_box.visible = false
		
	if Input.is_action_just_released("alternate_command"):
		select_units(mouse_position)

func calc_move(mouse_position: Vector2, delta: float) -> void:
	var v_size: Vector2 = get_viewport().size
	var move_vec: Vector3 = Vector3.ZERO

	if mouse_position.x < MOVE_MARGIN:
		move_vec.x -= 1
	if mouse_position.y < MOVE_MARGIN:
		move_vec.z -= 1
	if mouse_position.x > v_size.x - MOVE_MARGIN:
		move_vec.x += 1
	if mouse_position.y > v_size.y - MOVE_MARGIN:
		move_vec.z += 1

	move_vec = move_vec.rotated(Vector3.UP, rotation.y)
	translate(move_vec * delta * MOVE_SPEED)

func move_selected_units(mouse_position):
	var result = raycast_from_mouse(mouse_position, 1)
	if result:
		for unit in selected_units:
			unit.move_to(result.position)

func select_units(mouse_position):
	var new_selected_units = []
	if mouse_position.distance_squared_to(start_selection_position) < 16:
		var unit = get_unit_under_mouse(mouse_position)
		if unit != null:
			new_selected_units.append(unit)
	else:
		new_selected_units = get_units_in_box(start_selection_position, mouse_position)
		
	if new_selected_units.size() != 0:
		for unit in selected_units:
			unit.deselect()
		for unit in new_selected_units:
			unit.select()
		selected_units = new_selected_units
		
func get_unit_under_mouse(mouse_position):
	var result = raycast_from_mouse(mouse_position, 3)
	if result and "team" in result.collider and result.collider.team == team:
		return result.collider
		
func get_units_in_box(top_left, bottom_right):
	if top_left.x > bottom_right.x:
		var tmp = top_left.x
		top_left.x = bottom_right.x
		bottom_right.x = tmp
	if top_left.y > bottom_right.y:
		var tmp = top_left.y
		top_left.y = bottom_right.y
		bottom_right.y = tmp
		
	var box = Rect2(top_left, bottom_right - top_left)
	var box_selected_units = []
	
	for unit in get_tree().get_nodes_in_group("units"):
		if box.has_point(camera.unproject_position(unit.global_transform.origin)):
			box_selected_units.append(unit)
	return box_selected_units

func raycast_from_mouse(mouse_position: Vector2, collision_mask: int):
	var space_state = get_world_3d().direct_space_state

	var ray_origin: Vector3 = camera.project_ray_origin(mouse_position)
	var ray_normal: Vector3 = camera.project_ray_normal(mouse_position)
	var ray_end: Vector3 = ray_origin + (ray_normal * RAY_LENGTH)

	var intersect_ray_params := PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	intersect_ray_params.collision_mask = collision_mask

	return space_state.intersect_ray(intersect_ray_params)
