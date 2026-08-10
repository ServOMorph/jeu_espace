class_name CameraRig
extends RefCounted

## Etat et orientation d'une camera a la premiere personne : yaw autour de `haut`, pitch
## autour de l'axe "droite" qui en decoule, `avant` etant la direction de reference a
## yaw = pitch = 0. `avant`/`haut` sont parametrables pour rester utilisable dans un
## repere local ou "haut" n'est pas Vector3.UP (cf. repere du vaisseau, dorsal = +Z).
##
## Yaw illimite (bornes par defaut, cercle complet) : wrap continu, necessaire pour une
## rotation 360 sans a-coup (observatoire). Bornes de yaw serrees (cockpit, cone
## avant) : clamp au lieu du wrap, aucune valeur hors cone atteignable.

const PITCH_MIN_DEFAUT := -PI / 2.0 + 0.01
const PITCH_MAX_DEFAUT := PI / 2.0 - 0.01
const YAW_MIN_DEFAUT := -PI
const YAW_MAX_DEFAUT := PI
const YAW_CERCLE_COMPLET := TAU - 0.0001

var yaw := 0.0
var pitch := 0.0
var sensibilite: float
var pitch_min: float
var pitch_max: float
var yaw_min: float
var yaw_max: float
var avant: Vector3
var haut: Vector3


func _init(
	sensibilite_ := 0.003,
	pitch_min_: float = PITCH_MIN_DEFAUT,
	pitch_max_: float = PITCH_MAX_DEFAUT,
	avant_ := Vector3(0.0, 1.0, 0.0),
	haut_ := Vector3(0.0, 0.0, 1.0),
	yaw_min_: float = YAW_MIN_DEFAUT,
	yaw_max_: float = YAW_MAX_DEFAUT
) -> void:
	sensibilite = sensibilite_
	pitch_min = pitch_min_
	pitch_max = pitch_max_
	avant = avant_.normalized()
	haut = haut_.normalized()
	yaw_min = yaw_min_
	yaw_max = yaw_max_


func appliquer_delta_souris(delta: Vector2) -> void:
	if yaw_max - yaw_min >= YAW_CERCLE_COMPLET:
		yaw = wrapf(yaw - delta.x * sensibilite, -PI, PI)
	else:
		yaw = clampf(yaw - delta.x * sensibilite, yaw_min, yaw_max)
	pitch = clampf(pitch - delta.y * sensibilite, pitch_min, pitch_max)


## Direction regardee, exprimee dans le meme repere que `avant`/`haut`.
func direction() -> Vector3:
	var droite := avant.cross(haut).normalized()
	var avant_yaw := avant.rotated(haut, yaw)
	var droite_yaw := droite.rotated(haut, yaw)
	return avant_yaw.rotated(droite_yaw, pitch).normalized()


## Basis orientant une camera vers `direction()`, `haut` comme reference verticale.
func basis() -> Basis:
	return Basis.looking_at(direction(), haut)
