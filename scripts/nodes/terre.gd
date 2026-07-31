extends MeshInstance3D


func _ready() -> void:
	var sphere := mesh as SphereMesh
	sphere.radius = WorldScale.rayon_terre_unites()
	sphere.height = sphere.radius * 2.0
