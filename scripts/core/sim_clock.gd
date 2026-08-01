class_name SimClock
extends RefCounted

## Horloge de simulation : accumule le temps simule independamment du temps reel.
## Le multiplicateur ne provoque jamais de saut ni de derive car le temps simule
## est accumule a chaque avancer(), jamais recalcule depuis un instant de depart
## multiplie.

const MULTIPLICATEUR_X1 := 1.0
const MULTIPLICATEUR_X10 := 10.0
const MULTIPLICATEUR_X60 := 60.0

var temps_simule := 0.0
var multiplicateur := MULTIPLICATEUR_X1


func avancer(delta_reel: float) -> void:
	temps_simule += delta_reel * multiplicateur


func definir_multiplicateur(valeur: float) -> void:
	multiplicateur = valeur
