# Handoff — Phase D4 (Instruments 2D du cockpit) → dev phase 5 (cockpit)

## Livrables
- `DESIGN/instruments/notes.md` — composition console avant, dimensionnement, description des assets
- `DESIGN/instruments/vue_console.svg` — plan coté de la console avant (schéma technique, style D2/D3)
- `DESIGN/instruments/instrument_ecran.svg` — écran central, asset vectoriel, fond opaque
- `DESIGN/instruments/instrument_cadran.svg` — cadran rond, asset vectoriel, fond transparent
- `DESIGN/charte.md` § Palette > Instruments cockpit — valeurs chiffrées (hex)

Toutes les valeurs sont relatives à la longueur totale du vaisseau `L = 1.0`.

## Points clés pour l'implémentation

- **Console avant** : 0.10 L x 0.03 L, sous la baie vitrée frontale du cockpit.
- **Écran central** : 0.04 L x 0.02 L, centré. Asset `instrument_ecran.svg` à fond opaque
  `#12161B` — destiné à une texture de console, pas à un overlay.
- **Cadrans (x2)** : Ø 0.015 L, de part et d'autre de l'écran. Asset `instrument_cadran.svg` à
  fond transparent — destiné à un overlay ou une texture individuelle appliquée sur le cadran.
- **Bandeau de voyants** : 0.04 L x 0.005 L, 6 points lumineux ponctuels, sous l'écran.
- **Statique uniquement** : aucune donnée live, aucun instrument fonctionnel (pas de pilotage au
  MVP). Ne pas câbler ces assets à une quelconque valeur variable.
- **Résolution** : assets vectoriels (SVG), la contrainte « au moins double de la taille
  d'affichage » est satisfaite nativement par mise à l'échelle sans perte.
- Rappel Phase D4/roadmap : le vaisseau ne doit **pas** être visible depuis le cockpit (contrainte
  déjà tenue par la géométrie D2, cf. `proportions.md`).

### Palette (valeurs chiffrées dans `charte.md`)
- Écran : fond `#12161B`, cadre `#3A4048`, motif statique `#4FD8E0` à faible opacité.
- Cadrans : fond `#1B2129`, cadre `#3A4048`, aiguille et graduations `#4FD8E0`.

## Écarts au périmètre initial
Set d'instruments limité à un minimal générique (écran central + 2 cadrans + bandeau de voyants),
décision de session du 2026-08-01 — aucune fonction pilotée n'existant au MVP, un jeu
d'instruments détaillé/thématique n'apportait pas de valeur supplémentaire.

## Tests manuels à ajouter dans `DEV/tests_manuels.md`
- « Instruments de la console avant lisibles à taille d'affichage réelle (1920x1080, vue de face
  à courte distance), pas seulement à 100 % dans un éditeur d'image. »
- « Aucun élément de coque visible dans tout le débattement de la caméra cockpit. »
