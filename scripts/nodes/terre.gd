extends MeshInstance3D

@export var soleil_path: NodePath


func _ready() -> void:
	var sphere := mesh as SphereMesh
	sphere.radius = WorldScale.rayon_terre_unites()
	sphere.height = sphere.radius * 2.0
	_pousser_direction_soleil()


func _pousser_direction_soleil() -> void:
	var materiau := (mesh as SphereMesh).material as ShaderMaterial
	if materiau == null:
		return
	var soleil := get_node_or_null(soleil_path) as Node3D
	if soleil == null:
		return
	materiau.set_shader_parameter(
		"direction_soleil", Eclairage.direction_vers_soleil(soleil.global_transform.basis)
	)
