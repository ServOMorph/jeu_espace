extends MeshInstance3D

const VITESSE_ROTATION_DEG_S := 0.5

var _rotation_deg := 0.0


func _ready() -> void:
	var sphere := mesh as SphereMesh
	sphere.radius = WorldScale.rayon_nuages_unites()
	sphere.height = sphere.radius * 2.0


func _process(delta: float) -> void:
	_rotation_deg = fmod(_rotation_deg + VITESSE_ROTATION_DEG_S * delta, 360.0)
	rotation_degrees.y = _rotation_deg
