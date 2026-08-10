class_name VolLibre
extends RefCounted

## Deplacement libre a la premiere personne : calcule le vecteur deplacement a partir
## d'une direction (dans le repere de la camera, pas necessairement normalisee) et d'un
## booleen "rapide". Reutilise par les cameras d'exploration libres (vaisseau, drone
## lointain) qui ne different que par l'echelle de vitesse et le repere.

var vitesse: float
var vitesse_rapide: float


func _init(vitesse_ := 25.0, vitesse_rapide_ := 250.0) -> void:
	vitesse = vitesse_
	vitesse_rapide = vitesse_rapide_


func deplacement(direction: Vector3, rapide: bool, delta: float) -> Vector3:
	if direction == Vector3.ZERO:
		return Vector3.ZERO
	var v := vitesse_rapide if rapide else vitesse
	return direction.normalized() * v * delta
