class_name Eclairage
extends RefCounted

## Logique d'eclairage jour/nuit, independante de tout noeud.
## Le facteur jour calcule ici reproduit exactement celui de res://shaders/terre.gdshader :
## toute modification de l'un doit etre reportee sur l'autre.

const LARGEUR_TERMINATEUR_DEFAUT := 0.15


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


## Ponderation appliquee aux lumieres urbaines : complement du facteur jour.
static func facteur_nuit(
	normale: Vector3,
	direction_soleil: Vector3,
	largeur_terminateur: float = LARGEUR_TERMINATEUR_DEFAUT
) -> float:
	return 1.0 - facteur_jour(normale, direction_soleil, largeur_terminateur)
