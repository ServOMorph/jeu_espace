# Intérieur de l'observatoire — notes de conception

Toutes les valeurs relatives à `L`, cohérentes avec `DESIGN/vaisseau/proportions.md`.

## Sol / structure / mobilier

| Élément | Valeur | Repère |
|---|---|---|
| Sol | ovale, diamètre 0.30 L | suit la base de la coupole, courbure du fuselage |
| Console centrale | 0.05 L x 0.04 L, hauteur 0.03 L | centrée sous le sommet |
| Coursive | anneau libre entre console et périmètre | circulation à 360° |
| Sièges (x2) | 0.02 L x 0.015 L | de part et d'autre de la console |
| Rangement bas | 0.05 L x 0.015 L | derrière la console |

Volume simple, low poly, cf. `interieur/vue_plan.svg` (plan) et `interieur/vue_coupe.svg` (coupe).

## Volet blindé rétractable — découpage

- **12 panneaux**, un par baie de l'armature (baies délimitées par les 12 montants radiaux
  espacés de 30°, cf. `proportions.md`). Un panneau = un secteur de 30°, courbé pour suivre la
  sphéricité de la coupole.
- **Sens d'ouverture** : translation radiale vers le bas, chaque panneau glisse le long du
  montant qui le borde (rail intégré au montant) et se range dans un **anneau de logement au
  niveau du cerclage de base**. Les 12 panneaux se retirent indépendamment mais de façon
  synchronisée (une seule commande joueur).
- **Aspect** : blindé, mat, opaque (`#33383E`), liseré de sécurité ambre (`#C97A2E`) sur les
  jointures/montants, visible volet fermé comme ouvert (reste sur le montant, pas sur le
  panneau).
- **État fermé** : les 12 panneaux couvrent entièrement les baies, aucune vue vers l'extérieur.
  Cf. `volet_ferme.svg`.
- **État ouvert** : panneaux rangés dans l'anneau de base, baies dégagées, coque et espace
  visibles entre les montants (contrainte D2 tenue). Cf. `volet_ouvert.svg`.

## Palette
Voir `DESIGN/charte.md` § Palette > Intérieur observatoire.
