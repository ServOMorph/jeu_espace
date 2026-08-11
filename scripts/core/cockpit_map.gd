class_name CockpitMap
extends RefCounted

## Projection des positions de la Terre, de la Lune et du Soleil sur l'ecran MAP du
## cockpit. Vue depuis le vaisseau, sur les memes axes que camera_rig.gd (avant =
## repere.basis.y, haut de reference = repere.basis.z, cf. RepereVaisseau) pour rester
## coherente avec l'orientation du cockpit.
##
## Projection azimutale equidistante centree sur l'avant du vaisseau : le centre du
## disque est l'avant, le bord est l'arriere (angle de PI radians), quelle que soit la
## distance reelle des corps representes.

const DEMI_TOUR := PI


## Direction unitaire, dans le repere monde (planetaire), du vaisseau vers `position_monde`.
static func direction_vers(origine_vaisseau: Vector3, position_monde: Vector3) -> Vector3:
	return (position_monde - origine_vaisseau).normalized()


## Projette une direction monde (unitaire) sur le disque [-1, 1] x [-1, 1] de la carte,
## dans le repere du vaisseau donne par `repere` (issu de Orbit.frame_at).
static func projeter(direction_monde: Vector3, repere: Transform3D) -> Vector2:
	var avant := repere.basis.y.normalized()
	var haut := repere.basis.z.normalized()
	var droite := avant.cross(haut).normalized()
	var d := direction_monde.normalized()
	var angle := acos(clampf(d.dot(avant), -1.0, 1.0))
	var rayon := angle / DEMI_TOUR
	var phi := atan2(d.dot(droite), d.dot(haut))
	return Vector2(rayon * sin(phi), -rayon * cos(phi))


## Positions [-1,1]x[-1,1] de la Terre, de la Lune et du Soleil sur la carte, a l'instant
## dont `repere` est issu. `position_lune_monde` vient de la position (fixe au MVP) de
## scenes/lune.tscn ; `direction_soleil_monde` du Soleil, traite comme une source a
## l'infini (Eclairage.direction_vers_soleil), pas comme une position.
static func positions_carte(
	repere: Transform3D, position_lune_monde: Vector3, direction_soleil_monde: Vector3
) -> Dictionary:
	return {
		"terre": projeter(direction_vers(repere.origin, Vector3.ZERO), repere),
		"lune": projeter(direction_vers(repere.origin, position_lune_monde), repere),
		"soleil": projeter(direction_soleil_monde, repere),
	}
