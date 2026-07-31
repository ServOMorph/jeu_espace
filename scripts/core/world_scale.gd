class_name WorldScale
extends RefCounted

## Source unique des constantes d'echelle du projet.
## Aucune valeur d'echelle ne doit etre ecrite en dur ailleurs.
## Convention : 1 unite Godot = KM_PAR_UNITE kilometres.

const KM_PAR_UNITE := 100.0

const RAYON_TERRE_KM := 6371.0
const ALTITUDE_ORBITE_KM := 400.0

const RAYON_LUNE_KM := 1737.4
const DISTANCE_LUNE_KM := 384400.0

## Le Soleil n'est pas a sa distance reelle : elle placerait la geometrie hors du
## far plane utilisable. Il est place a une distance arbitraire, son rayon etant
## derive pour conserver le diametre apparent reel vu depuis la Terre.
const SOLEIL_DISTANCE_UNITES := 8000.0
const SOLEIL_DIAMETRE_APPARENT_DEG := 0.533


static func km_vers_unites(km: float) -> float:
	return km / KM_PAR_UNITE


static func unites_vers_km(unites: float) -> float:
	return unites * KM_PAR_UNITE


static func rayon_terre_unites() -> float:
	return km_vers_unites(RAYON_TERRE_KM)


## Rayon du rail orbital mesure depuis le centre de la Terre.
static func rayon_orbite_unites(altitude_km: float = ALTITUDE_ORBITE_KM) -> float:
	return km_vers_unites(RAYON_TERRE_KM + altitude_km)


static func rayon_lune_unites() -> float:
	return km_vers_unites(RAYON_LUNE_KM)


static func distance_lune_unites() -> float:
	return km_vers_unites(DISTANCE_LUNE_KM)


## Rayon a donner a une sphere placee a `distance_unites` pour qu'elle sous-tende
## `diametre_apparent_deg` depuis l'origine.
static func rayon_pour_diametre_apparent(distance_unites: float, diametre_apparent_deg: float) -> float:
	return distance_unites * tan(deg_to_rad(diametre_apparent_deg) * 0.5)


static func rayon_soleil_unites() -> float:
	return rayon_pour_diametre_apparent(SOLEIL_DISTANCE_UNITES, SOLEIL_DIAMETRE_APPARENT_DEG)


## Diametre apparent, en degres, d'une sphere de rayon `rayon_unites` vue de `distance_unites`.
## Reciproque de `rayon_pour_diametre_apparent`.
static func diametre_apparent_deg(rayon_unites: float, distance_unites: float) -> float:
	if distance_unites <= 0.0:
		return 0.0
	return rad_to_deg(atan(rayon_unites / distance_unites)) * 2.0
