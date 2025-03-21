extends Node3D

const MOVE_MARGIN = 20
const MOVE_SPEED = 30
const RAY_LENGTH = 1000

@onready var cam: Camera3D = $Camera3D

func _process(delta: float) -> void:
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	calc_move(mouse_position, delta)
	
	if Input.is_action_just_pressed("main_command"):
		move_all_units(mouse_position)

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

func move_all_units(mouse_position):
	var result = raycast_from_mouse(mouse_position, 1)
	print(result)
	if result:
		print("result")
		get_tree().call_group("units", "move_to", result.position)

func raycast_from_mouse(mouse_position: Vector2, collision_mask: int):
	var space_state = get_world_3d().direct_space_state

	var ray_origin: Vector3 = cam.project_ray_origin(mouse_position)
	var ray_normal: Vector3 = cam.project_ray_normal(mouse_position)
	var ray_end: Vector3 = ray_origin + (ray_normal * RAY_LENGTH)

	var intersect_ray_params := PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	intersect_ray_params.collision_mask = collision_mask

	return space_state.intersect_ray(intersect_ray_params)
