extends CharacterBody3D

var path = []
var path_ind = 0
const SPEED = 12

@onready var nav = get_parent()

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_ind = 0
	
func _physics_process(_delta: float) -> void:
	if path_ind < path.size():
		var move_vec = (path[path_ind] - global_transform.origin)
		if move_vec.length() < 0.1:
			path_ind += 1
		else:
			self.up_direction = Vector3(0, 1, 0)
			self.velocity = SPEED * move_vec.normalized()
			move_and_slide()
