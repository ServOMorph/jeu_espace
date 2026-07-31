extends MeshInstance3D


func _ready() -> void:
	var sphere := mesh as SphereMesh
	sphere.radius = WorldScale.rayon_lune_unites()
	sphere.height = sphere.radius * 2.0
	position = Vector3(WorldScale.distance_lune_unites(), 0.0, 0.0)
