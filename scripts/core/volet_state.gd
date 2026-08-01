class_name VoletState
extends RefCounted

## Machine a etats du volet blinde de la coupole. `progression` va de 0 (ferme) a 1 (ouvert).
## `toggle` inverse le sens sans jamais sauter de valeur : une inversion en cours
## d'animation repart de la progression courante.

enum Etat { FERME, EN_OUVERTURE, OUVERT, EN_FERMETURE }

const DUREE_S_DEFAUT := 3.0

var etat := Etat.FERME
var progression := 0.0
var duree_s: float


func _init(duree_s_ := DUREE_S_DEFAUT) -> void:
	duree_s = duree_s_


func toggle() -> void:
	match etat:
		Etat.FERME:
			etat = Etat.EN_OUVERTURE
		Etat.OUVERT:
			etat = Etat.EN_FERMETURE
		Etat.EN_OUVERTURE:
			etat = Etat.EN_FERMETURE
		Etat.EN_FERMETURE:
			etat = Etat.EN_OUVERTURE


func avancer(delta: float) -> void:
	if etat == Etat.FERME or etat == Etat.OUVERT:
		return
	var pas := delta / duree_s
	if etat == Etat.EN_OUVERTURE:
		progression = clampf(progression + pas, 0.0, 1.0)
		if progression >= 1.0:
			etat = Etat.OUVERT
	else:
		progression = clampf(progression - pas, 0.0, 1.0)
		if progression <= 0.0:
			etat = Etat.FERME
