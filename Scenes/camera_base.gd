extends Node3D

const MOVE_MARGIN = 20
const MOVE_SPEED = 30

const ray_length = 1000
@onready var cam = $Camera3D

func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	calc_move(mouse_position, delta)
	if Input.is_action_just_pressed("main_command"):
		move_all_units(mouse_position)
		
func calc_move(mouse_position, delta):
	var v_size = get_viewport().size
	var move_vec = Vector3()
	if mouse_position.x < MOVE_MARGIN:
		move_vec.x -= 1
	if mouse_position.y < MOVE_MARGIN:
		move_vec.z -= 1
	if mouse_position.x > v_size.x - MOVE_MARGIN:
		move_vec.x += 1
	if mouse_position.y > v_size.y - MOVE_MARGIN:
		move_vec.z += 1
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation_degrees.y)
	global_translate(move_vec * delta * MOVE_SPEED)
	
func move_all_units(mouse_position):
	var result = raycast_from_mouse(mouse_position, 1)
	if result:
		get_tree().call_group("units", "move_to", result.position)
		
func raycast_from_mouse(mouse_position, collision_mask):
	var ray_start = cam.project_ray_origin(mouse_position)
	var ray_end = ray_start + cam.project_ray_normal(mouse_position) * ray_length
	var space_state = get_world_3d().direct_space_state
	
	var intersect_ray_params = PhysicsRayQueryParameters3D.new()
	intersect_ray_params.from = ray_start
	intersect_ray_params.to = ray_end
	intersect_ray_params.exclude = []
	intersect_ray_params.collision_mask = collision_mask
	return space_state.intersect_ray(intersect_ray_params)
	
