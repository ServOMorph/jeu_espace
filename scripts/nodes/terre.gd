extends MeshInstance3D

@export var soleil_path: NodePath

var _horloge: Node


func _ready() -> void:
	var sphere := mesh as SphereMesh
	sphere.radius = WorldScale.rayon_terre_unites()
	sphere.height = sphere.radius * 2.0
	_pousser_direction_soleil()


## L'horloge vit hors du SubViewport lointain : elle est retrouvee par groupe plutot que
## par NodePath, qui devrait alors traverser la frontiere de scene instanciee.
func _process(_delta: float) -> void:
	if _horloge == null:
		_horloge = get_tree().get_first_node_in_group("horloge")
		if _horloge == null:
			return
	basis = SunDirection.rotation_terre(_horloge.temps_simule())


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
