extends Spatial

const SCORE_VALUE = [1,18,4,13,6,10,15,2,17,3,  20,5,12,9,14,11,8,16,7,19]

var s50 = 0.0
var s25 = 0.0
var sInner = 0.0
var sX3 = 0.0
var sOuter = 0.0
var sX2 = 0.0

func _ready():
	pass # Replace with function body.
	$zoom/Viewport/Control/Label.text = "tesssssssst"
	s50 = $board/boardStatic/s50.transform.origin.z
	s25 = $board/boardStatic/s25.transform.origin.z
	sInner = $board/boardStatic/sInner.transform.origin.z
	sX3 = $board/boardStatic/sX3.transform.origin.z
	sOuter = $board/boardStatic/sOuter.transform.origin.z
	sX2 = $board/boardStatic/sX2.transform.origin.z

func button_pressed_released(button_id, hand = 'l', is_presed = true):
	pass

func select_dart():
	if $darts.get_child_count() > 0:
		for d in $darts.get_children():
			if !d.visible:
				return d
	return null

func throw_dart(dart, velocity, dart_transform):
	dart.get_parent().remove_child(dart)
	$darts.add_child(dart)
	dart.global_transform = dart_transform
	dart.activate(velocity * 1.5, true)

func get_new_score(pos, scored = true):
	var board_local_pos = $board/boardStatic.to_local(pos)
	var pos2d = Vector2(board_local_pos.x, board_local_pos.z)
	var hit_angle = Vector2(0,-1).angle_to(pos2d.normalized()) / PI * 180.0
	
	var angle_index = int(hit_angle / 18.0)
	if (sign(hit_angle) < 0):
		angle_index = abs(angle_index) + 10
	var base_score = SCORE_VALUE[angle_index]
	var hit_dist = pos2d.length()
	var mess = ""
	var score = 0
	if (!scored):
		mess = "Miss!"
	elif hit_dist < s50:
		score = 50
		mess = String(score)
	elif hit_dist < s25:
		score = 25
		mess = String(score)
	elif hit_dist < sInner:
		score = base_score
		mess = String(score)
	elif hit_dist < sX3:
		score = base_score * 3
		mess = String(base_score) + " X 3 = " + String(score)
	elif hit_dist < sOuter:
		score = base_score
		mess = String(score)
	elif hit_dist < sX2:
		score = base_score * 2
		mess = String(base_score) + " X 2 = " + String(score)
	else:
		score = 0
		mess = String(score)
	$zoom/Viewport/Control/Label.text = String(hit_angle) + \
		"  " + String(pos2d.length()) + "\n" + String(SCORE_VALUE[angle_index]) + \
		"  Score: " + mess

func update_ingame_screen():
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	$zoom/Viewport.render_target_update_mode = Viewport.UPDATE_ONCE
