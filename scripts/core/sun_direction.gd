class_name SunDirection
extends RefCounted

## Rotation propre de la Terre, derivee du temps simule pour rester coherente
## avec l'horloge (source unique, pas de derive possible). L'orbite terrestre
## autour du Soleil n'est pas simulee au MVP : seule la rotation propre de la
## Terre produit le cycle jour/nuit, la direction du Soleil restant fixe en
## espace monde (Eclairage.direction_vers_soleil).
##
## Periode calee sur celle de l'orbite basse du vaisseau (~90 min, cf.
## roadmap_dev.md Phase 2) et non sur le jour sideral reel (86164 s) : a cette
## echelle reelle, meme x60 ne produit qu'une rotation imperceptible sur une
## session de test de quelques dizaines de secondes.

const PERIODE_ROTATION_TERRE_S := 5400.0


## Angle de rotation propre de la Terre autour de Vector3.UP, periodique.
static func angle_rotation_terre(temps_simule: float, periode_s: float = PERIODE_ROTATION_TERRE_S) -> float:
	return fmod(temps_simule, periode_s) / periode_s * TAU


## Basis a appliquer au noeud Terre a l'instant t pour representer sa rotation propre.
static func rotation_terre(temps_simule: float, periode_s: float = PERIODE_ROTATION_TERRE_S) -> Basis:
	return Basis(Vector3.UP, angle_rotation_terre(temps_simule, periode_s))
