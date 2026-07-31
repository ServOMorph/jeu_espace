# Handoff — Phase D2 (Forme du vaisseau) → dev phase 3 (mesh)

## Livrables
Voir `DESIGN/vaisseau/proportions.md` — dimensionnement chiffré complet, validé.
Planches (schémas techniques cotés, pas de rendu artistique) :
- `DESIGN/vaisseau/vue_face.svg`
- `DESIGN/vaisseau/vue_cote.svg`
- `DESIGN/vaisseau/vue_dessus.svg`

Toutes les valeurs sont relatives à la longueur totale du vaisseau `L = 1.0`.

## Points clés pour la modélisation
- Coque : fuselage effilé, diamètre max 0.22 L à 0.35 L depuis l'avant.
- Coupole (centre de commande) : diamètre 0.30 L, centrée à 0.55 L, sommet à 0.30 L au-dessus de
  l'axe du fuselage. Armature seule à modéliser (12 montants radiaux espacés de 30°, 3 cerclages
  horizontaux) : aucune vitre côté intérieur (contrainte tri de rendu, cf. Phase D3).
- Cockpit : section fermée à l'avant (0 à 0.15 L), sans ligne de vue vers le reste de la coque.
- Structures externes : 2 panneaux solaires (0.40 L x 0.15 L, centrés à 0.45-0.85 L), 2 antennes
  (0.10 L, arrière), 2 nacelles moteur (diamètre 0.08 L, longueur 0.12 L, arrière).

## Écarts au périmètre initial
Aucun. Proportions proposées par `design` et validées par l'utilisateur en session.

## Test manuel à ajouter dans `DEV/tests_manuels.md`
- « Depuis le centre de commande sous coupole, la coque et les structures externes sont visibles
  et lisibles entre les montants de l'armature. »
