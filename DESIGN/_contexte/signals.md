# Signals — design   (MAJ 2026-08-11)

## Actions ouvertes
- [P2|ouvert] Phase D5 (passe visuelle finale) : attendre le retour de `dev` sur le rendu en situation (exposition, contraste Terre/espace, halo atmosphérique) avant de pouvoir juger/corriger les assets.
  fait quand: `dev` a livré un rendu intégré (phase 6 polish) et signalé les assets insuffisants, ou confirmé qu'aucun ne l'est.
  réf: DESIGN/roadmap_design.md (Phase D5)

## Dernière session (2026-08-11)
# Session du 2026-08-11

## Décisions prises
- `proportions.md` § Coupole — observatoire resynchronisé sur le repositionnement ventral (nadir) de la coupole/observatoire, déjà appliqué côté `dev` le 2026-08-04 (`DEV/roadmap_dev.md`, Phase 4).
- Cerclage mi-hauteur de l'armature (§ Armature de la coupole) corrigé pour cohérence : restait « au-dessus de l'axe », incohérent avec le sommet désormais en dessous.
- Planches `vue_cote.svg` et `vue_face.svg` corrigées en miroir (coupole, armature, cotations) pour représenter le positionnement ventral. `vue_dessus.svg` jugée non affectée (vue en plan, dorsal/ventral non représenté).

## Livrables produits ou modifiés
- DESIGN/vaisseau/proportions.md : § Coupole — observatoire, § Armature, § Statut corrigés
- DESIGN/vaisseau/vue_cote.svg : coupole/armature/cotation repositionnées côté ventral
- DESIGN/vaisseau/vue_face.svg : idem

## Hypothèses validées / invalidées
- VALIDE : aucun changement côté `dev` requis, le code (`scenes/vaisseau.tscn`) était déjà conforme depuis le 2026-08-04.
- VALIDE : `vue_dessus.svg` ne nécessite pas de correction (vue en plan).

## Prochaine étape exacte
Phase D5 (passe visuelle finale) toujours bloquée : attendre un rendu `dev` en situation.

## Question bloquante pour la session suivante
Aucune
