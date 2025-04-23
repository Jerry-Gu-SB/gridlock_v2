extends CharacterBody3D

@export var team = 0

var path: PackedVector3Array = []
var path_ind: int = 0

const SPEED: float = 6

var highlighted_by_deathzone := false
var deathzone_count: int = 0

var material_standard = preload("res://Materials/unit_standard.tres")
var material_danger = preload("res://Materials/unit_danger.tres")

@onready var nav: Node3D = get_parent()
@onready var nav_agent = $NavigationAgent3D
@onready var selection_ring : MeshInstance3D = $SelectionRing
@onready var body_mesh : MeshInstance3D = $Body

func _ready():
	selection_ring.visible = false
	GlobalTimer.timer_expired.connect(_on_timer_expired)
	
func _on_timer_expired():
	if deathzone_count > 0:
		return

	var dup = duplicate()
	dup.name = name + "_copy"
	dup.position += Vector3(1, 0, 0)
	dup.deathzone_count = 0
	dup.highlighted_by_deathzone = false

	if dup.body_mesh:
		dup.body_mesh.set_surface_override_material(0, material_standard)

	get_parent().add_child(dup)
	dup.deselect()
	
	dup.add_to_group("units")


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
	
func set_highlighted_by_deathzone(value: bool) -> void:
	if value:
		deathzone_count += 1
	else:
		deathzone_count = max(deathzone_count - 1, 0)

	var should_be_highlighted = deathzone_count > 0

	if highlighted_by_deathzone == should_be_highlighted:
		return

	highlighted_by_deathzone = should_be_highlighted

	if body_mesh:
		if highlighted_by_deathzone:
			body_mesh.set_surface_override_material(0, material_danger)
		else:
			body_mesh.set_surface_override_material(0, material_standard)
