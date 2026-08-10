class_name CameraOrbite
extends RefCounted

## Camera en orbite autour d'une cible fixe : yaw/pitch orientent le point de vue autour de
## `cible`, `distance` controle le zoom (dolly). Pitch borne pour eviter le retournement aux
## poles (comme CameraRig), distance bornee entre `distance_min` et `distance_max`.

const PITCH_MIN_DEFAUT := -PI / 2.0 + 0.05
const PITCH_MAX_DEFAUT := PI / 2.0 - 0.05

var yaw := 0.0
var pitch := 0.0
var distance: float
var distance_min: float
var distance_max: float
var sensibilite: float
var facteur_zoom: float
var pitch_min: float
var pitch_max: float
var cible: Vector3
var haut: Vector3
var avant: Vector3


func _init(
	distance_ := 10.0,
	distance_min_ := 1.0,
	distance_max_ := 100.0,
	sensibilite_ := 0.003,
	facteur_zoom_ := 0.9,
	pitch_min_: float = PITCH_MIN_DEFAUT,
	pitch_max_: float = PITCH_MAX_DEFAUT,
	cible_ := Vector3.ZERO,
	avant_ := Vector3(0.0, 1.0, 0.0),
	haut_ := Vector3(0.0, 0.0, 1.0)
) -> void:
	distance_min = distance_min_
	distance_max = distance_max_
	distance = clampf(distance_, distance_min, distance_max)
	sensibilite = sensibilite_
	facteur_zoom = facteur_zoom_
	pitch_min = pitch_min_
	pitch_max = pitch_max_
	cible = cible_
	avant = avant_.normalized()
	haut = haut_.normalized()


func appliquer_delta_souris(delta: Vector2) -> void:
	yaw = wrapf(yaw - delta.x * sensibilite, -PI, PI)
	pitch = clampf(pitch - delta.y * sensibilite, pitch_min, pitch_max)


## `crans` positif rapproche (zoom avant), negatif eloigne. Pas multiplicatif : confortable
## sur une large plage de distances (proche du vaisseau comme vue d'ensemble).
func appliquer_zoom(crans: float) -> void:
	distance = clampf(distance * pow(facteur_zoom, crans), distance_min, distance_max)


## Direction unitaire de la cible vers la camera.
func direction() -> Vector3:
	var droite := avant.cross(haut).normalized()
	var avant_yaw := avant.rotated(haut, yaw)
	var droite_yaw := droite.rotated(haut, yaw)
	return avant_yaw.rotated(droite_yaw, pitch).normalized()


func position() -> Vector3:
	return cible + direction() * distance


func basis() -> Basis:
	return Basis.looking_at(cible - position(), haut)
