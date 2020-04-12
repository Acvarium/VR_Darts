extends Spatial
const move_speed = 0.2

func _physics_process(delta):
	
	var cam_pos = $Camera.global_transform.origin
	cam_pos.y = $dart.global_transform.origin.y
	cam_pos.x = $dart.global_transform.origin.x
	$Camera.global_transform.origin = cam_pos


func place_dot(pos, pos2):
	$dot.global_transform.origin = pos
	$dot2.global_transform.origin = pos2
	
