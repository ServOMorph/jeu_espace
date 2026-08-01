class_name Eclairage
extends RefCounted

## Logique d'eclairage jour/nuit, independante de tout noeud.
## Le facteur jour calcule ici reproduit exactement celui de res://shaders/terre.gdshader :
## toute modification de l'un doit etre reportee sur l'autre.

const LARGEUR_TERMINATEUR_DEFAUT := 0.15

## Demi-largeur de la penombre, en unites planetaires, au bord de l'ombre portee.
const LARGEUR_PENOMBRE_DEFAUT := 1.0


## Direction unitaire pointant vers le Soleil, en espace monde.
## Convention posee par scenes/soleil.tscn : le noeud emet vers -Z local, le Soleil
## se trouve donc du cote +Z de sa base.
static func direction_vers_soleil(base_soleil: Basis) -> Vector3:
	return base_soleil.z.normalized()


## 1.0 en plein jour, 0.0 en pleine nuit, transition continue dans la bande
## d'incidence [-largeur_terminateur, +largeur_terminateur].
static func facteur_jour(
	normale: Vector3,
	direction_soleil: Vector3,
	largeur_terminateur: float = LARGEUR_TERMINATEUR_DEFAUT
) -> float:
	var incidence := normale.normalized().dot(direction_soleil.normalized())
	return smoothstep(-largeur_terminateur, largeur_terminateur, incidence)


## Fraction de lumiere solaire recue en `position` (repere planetaire, origine au centre
## de l'occulteur). 0.0 dans l'ombre portee de la sphere de rayon `rayon_occulteur`,
## 1.0 en pleine lumiere, transition continue sur le bord.
##
## Un objet en orbite ne s'assombrit pas parce que la direction du Soleil change — elle
## est fixe — mais parce que la Terre l'occulte. Sans ce facteur, un vaisseau reste
## eclaire sur toute son orbite, sous un angle qui tourne.
##
## Ombre cylindrique et non conique : a l'echelle du MVP, la difference tient dans la
## penombre, deja approximee par `largeur_penombre`.
static func facteur_eclipse(
	position: Vector3,
	direction_soleil: Vector3,
	rayon_occulteur: float,
	largeur_penombre: float = LARGEUR_PENOMBRE_DEFAUT
) -> float:
	var vers_soleil := direction_soleil.normalized()
	var le_long := position.dot(vers_soleil)
	if le_long >= 0.0:
		return 1.0
	var distance_axe := (position - vers_soleil * le_long).length()
	return smoothstep(
		rayon_occulteur - largeur_penombre, rayon_occulteur + largeur_penombre, distance_axe
	)


## Ponderation appliquee aux lumieres urbaines : complement du facteur jour.
static func facteur_nuit(
	normale: Vector3,
	direction_soleil: Vector3,
	largeur_terminateur: float = LARGEUR_TERMINATEUR_DEFAUT
) -> float:
	return 1.0 - facteur_jour(normale, direction_soleil, largeur_terminateur)
