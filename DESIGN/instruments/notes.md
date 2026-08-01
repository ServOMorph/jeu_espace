# Instruments 2D du cockpit — notes de conception

Set minimal générique (décision de session 2026-08-01) : ambiance seulement, aucun instrument
fonctionnel, aucune donnée live (pas de pilotage au MVP).

## Composition de la console avant

| Élément | Valeur | Repère |
|---|---|---|
| Console avant | 0.10 L x 0.03 L | face avant du cockpit, sous la baie vitrée |
| Écran central | 0.04 L x 0.02 L | centré |
| Cadrans (x2) | Ø 0.015 L | de part et d'autre de l'écran |
| Bandeau de voyants | 0.04 L x 0.005 L, 6 points | sous l'écran |

Cf. `vue_console.svg` (plan coté, même traitement schéma technique que D2/D3).

## Assets livrés

- `instrument_ecran.svg` — écran central. Fond opaque `#12161B`, cadre `#3A4048`, motif statique
  cyan `#4FD8E0` à faible opacité (pas de représentation de données réelles). Destiné à une
  **texture de console** (fond opaque), pas à un overlay.
- `instrument_cadran.svg` — cadran rond, aiguille fixe en position neutre, cadre `#3A4048`,
  fond `#1B2129`, aiguille et graduations `#4FD8E0`. **Fond transparent** (viewBox sans `rect`
  de fond) : destiné à un overlay ou une texture individuelle appliquée sur le cadran de la
  console.
- Les deux assets sont vectoriels (SVG) : la contrainte « résolution au moins double de la
  taille d'affichage » est satisfaite nativement (mise à l'échelle sans perte).

## Palette
Voir `DESIGN/charte.md` § Palette > Instruments cockpit.
