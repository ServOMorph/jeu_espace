class_name RepereVaisseau
extends RefCounted

## Repere local du vaisseau : 1 unite = 1 metre, vaisseau fixe a l'origine.
##
## Le monde est rendu a deux echelles. Le lointain (Terre, Lune, Soleil, ciel) reste en
## unites planetaires (WorldScale, 1 unite = 100 km) ; le vaisseau et son interieur sont
## en metres. Une camera unique ne peut couvrir les deux : observer un vaisseau de 60 m
## exige un near plane sous le metre, atteindre le Soleil exige un far plane a plus de
## 1e6 km, soit un rapport near/far de l'ordre de 1e9 qu'aucun z-buffer ne tient. Les
## deux echelles sont donc rendues par deux cameras dans deux viewports, composites l'un
## sur l'autre.
##
## Consequence a connaitre : le vaisseau ne bouge pas dans le repere metrique. C'est la
## camera lointaine qui reproduit son deplacement orbital, ce qui fait defiler la Terre
## derriere un vaisseau immobile. L'observation est equivalente, la geometrie rendue ne
## l'est pas.
##
## Limite assumee : le lointain est compose en fond, il ne partage pas le z-buffer du
## proche. La Terre ne peut donc jamais occulter le vaisseau. Sans effet au MVP, ou la
## camera reste sur le vaisseau ; visible uniquement avec la camera libre de debug, si
## on la place derriere la Terre. Ne pas tenter de corriger par un tri manuel : la
## reponse serait de rendre le vaisseau dans le monde lointain, ce que l'echelle interdit.

const LONGUEUR_VAISSEAU_M := 60.0
const METRES_PAR_KM := 1000.0


## Facteur a appliquer a un modele construit en unites relatives (L = 1.0, convention de
## DESIGN/vaisseau/proportions.md) pour l'exprimer dans le repere metrique.
static func echelle_modele_metres() -> float:
	return LONGUEUR_VAISSEAU_M


static func metres_par_unite_planetaire() -> float:
	return WorldScale.KM_PAR_UNITE * METRES_PAR_KM


static func metres_vers_unites_planetaires(metres: float) -> float:
	return metres / metres_par_unite_planetaire()


static func unites_planetaires_vers_metres(unites: float) -> float:
	return unites * metres_par_unite_planetaire()


## Transform de la camera lointaine reproduisant, en unites planetaires, la camera locale
## `cam_locale` (en metres) d'un vaisseau dont le repere orbital est `vaisseau_monde`.
## `vaisseau_monde.basis` doit etre orthonormee (cf. Orbit.frame_at).
static func transform_camera_lointaine(
	vaisseau_monde: Transform3D, cam_locale: Transform3D
) -> Transform3D:
	var decalage := vaisseau_monde.basis * cam_locale.origin
	var origine := vaisseau_monde.origin + decalage / metres_par_unite_planetaire()
	return Transform3D(vaisseau_monde.basis * cam_locale.basis, origine)


## Direction unitaire vers le Soleil, exprimee dans le repere local du vaisseau.
## Le vaisseau et le Soleil sont rendus dans deux mondes distincts : sans cette
## conversion, l'eclairage du vaisseau ne suivrait pas celui de la Terre.
static func direction_soleil_locale(
	vaisseau_monde: Transform3D, direction_soleil_monde: Vector3
) -> Vector3:
	return (vaisseau_monde.basis.inverse() * direction_soleil_monde).normalized()
