extends Spatial

func _ready():
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
#	$screen.get_surface_material(0).albedo_texture = $Sprite3D.texture
	
