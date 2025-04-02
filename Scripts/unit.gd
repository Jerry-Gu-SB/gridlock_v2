extends CharacterBody3D

@export var team = 0

var path: PackedVector3Array = []
var path_ind: int = 0
const SPEED: float = 6

@onready var nav: Node3D = get_parent()
@onready var nav_agent = $NavigationAgent3D
@onready var selection_ring = $SelectionRing

func move_to(target_pos: Vector3) -> void:
	path = get_navigation_path(global_position, target_pos)
	path_ind = 0
	if path.size() > 0:
		nav_agent.set_target_position(target_pos)

func _physics_process(_delta: float) -> void:
	if path_ind < path.size():
		var move_vec: Vector3 = (path[path_ind] - global_position)
		if move_vec.length() < 0.1:
			path_ind += 1
		else:
			self.up_direction = Vector3.UP
			self.velocity = move_vec.normalized() * SPEED
			move_and_slide()

func get_navigation_path(p_start_position: Vector3, p_target_position: Vector3) -> PackedVector3Array:
	if not is_inside_tree():
		return PackedVector3Array()

	var default_map_rid: RID = get_world_3d().get_navigation_map()
	var navigation_path: PackedVector3Array = NavigationServer3D.map_get_path(
		default_map_rid,
		p_start_position,
		p_target_position,
		1
	)
	return navigation_path
	
func select():
	selection_ring.show()
	
func deselect():
	selection_ring.hide()
