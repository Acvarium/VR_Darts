extends RigidBody

onready var main_node = get_tree().get_root().get_node("main")
var last_transform : Transform
export var to_activet_on_start = false
var stop_point = Vector3()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	if to_activet_on_start:
		activate(Vector3(), true)

func _hide():
	mode = RigidBody.MODE_KINEMATIC
	visible = false
	transform = Transform()
	

func activate(velocity = Vector3(), to_activate = true):
	if to_activate:
		mode = RigidBody.MODE_RIGID
		apply_central_impulse(velocity)
		$reset_timer.start()
		last_transform = global_transform
	else:
		mode = RigidBody.MODE_KINEMATIC
		linear_velocity = Vector3()
		angular_velocity = Vector3()
		
func _on_reset_timer_timeout():
	_hide()
	
func _physics_process(delta):
	if (stop_point != Vector3()):
		global_transform.origin = stop_point
		stop_point = Vector3()
	if mode != RigidBody.MODE_RIGID:
		return
	apply_impulse(transform.basis.z * 0.018, -linear_velocity * 0.015)
	$RayCast.cast_to = Vector3(0,0,-(abs(linear_velocity.length()) * delta))
	if $RayCast.is_colliding():
		main_node.update_ingame_screen()
		if linear_velocity.normalized().dot((-transform.basis.z).normalized()) < 0.6:
			return
		if $RayCast.get_collider().is_in_group("dart"):
			return
		if $RayCast.get_collider().is_in_group("board"):
			main_node.get_new_score($RayCast.get_collision_point())
		else:
			main_node.get_new_score($RayCast.get_collision_point(), false)
		print($RayCast.get_collider().name)
		#main_node.place_dot($RayCast.get_collision_point(), global_transform.origin)
		activate(Vector3(), false)
		var hit_point = $RayCast.get_collision_point()
		var current_point = global_transform.origin
		var hit_dir = current_point.direction_to(hit_point)
		stop_point = hit_point - hit_dir * 0.07
#		$hit_sound.play()
