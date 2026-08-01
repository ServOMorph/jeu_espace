class_name Orbit
extends RefCounted

## Orbite circulaire pure, sans reference a un noeud ni au SceneTree.
## Plan de reference XZ, incline autour de l'axe X par `inclinaison_rad`.

var rayon_unites: float
var periode_s: float
var inclinaison_rad: float
var phase_depart_rad: float


func _init(
	p_rayon_unites: float,
	p_periode_s: float,
	p_inclinaison_rad: float = 0.0,
	p_phase_depart_rad: float = 0.0
) -> void:
	rayon_unites = p_rayon_unites
	periode_s = p_periode_s
	inclinaison_rad = p_inclinaison_rad
	phase_depart_rad = p_phase_depart_rad


## Phase de depart placant le point initial de l'orbite au plus pres de `direction`.
## Passer la direction du Soleil pour que la simulation demarre de jour (exigence
## roadmap_dev.md phase 2). La composante hors du plan orbital est inatteignable : elle
## est ignoree, le resultat est le point du plan le mieux oriente.
static func phase_pour_direction(direction: Vector3, inclinaison_rad: float) -> float:
	var dans_le_plan := direction.rotated(Vector3.RIGHT, -inclinaison_rad)
	return atan2(dans_le_plan.z, dans_le_plan.x)


func _angle_at(t: float) -> float:
	return phase_depart_rad + TAU * t / periode_s


## Position sur l'orbite a l'instant t, mesuree depuis le centre.
func position_at(t: float) -> Vector3:
	var angle := _angle_at(t)
	var point := Vector3(rayon_unites * cos(angle), 0.0, rayon_unites * sin(angle))
	return point.rotated(Vector3.RIGHT, inclinaison_rad)


## Direction tangente unitaire au sens du mouvement, orthogonale au rayon.
func tangent_at(t: float) -> Vector3:
	var angle := _angle_at(t)
	var derivee := Vector3(-sin(angle), 0.0, cos(angle))
	return derivee.rotated(Vector3.RIGHT, inclinaison_rad).normalized()


## Repere orthonormal du vaisseau sur l'orbite a l'instant t, dans la convention du
## modele (cf. scenes/vaisseau.tscn) : Y = avant (tangente), Z = dorsal (zenith),
## X = tribord (hors du plan orbital).
func frame_at(t: float) -> Transform3D:
	var pos := position_at(t)
	var avant := tangent_at(t)
	var zenith := pos.normalized()
	var tribord := avant.cross(zenith).normalized()
	var dorsal := tribord.cross(avant).normalized()
	return Transform3D(Basis(tribord, avant, dorsal), pos)
