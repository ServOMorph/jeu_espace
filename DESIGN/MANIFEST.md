# Manifest — inventaire des livrables

| fichier | résolution | format | phase | statut |
|---|---|---|---|---|
| terre_albedo_21600x10800.jpg | 21600x10800 | jpg | D1 | livré |
| terre_nightlights_13500x6750.jpg | 13500x6750 | jpg | D1 | livré |
| terre_clouds_2048x1024.jpg | 2048x1024 | jpg (masque de gris, pas d'alpha réel — à utiliser comme alpha map en shader côté dev) | D1 | livré |
| lune_albedo_8k.jpg | 8192x4096 | jpg | D1 | livré |
| etoiles_8k.jpg | 8192x4096 | jpg | D1 | livré |

| proportions.md | — | md | D2 | livré |
| vue_face.svg | 900x500 | svg (schéma technique coté) | D2 | livré |
| vue_cote.svg | 900x500 | svg (schéma technique coté) | D2 | livré |
| vue_dessus.svg | 900x500 | svg (schéma technique coté) | D2 | livré |

| notes.md | — | md | D3 | livré |
| vue_plan.svg | 900x500 | svg (schéma technique coté, plan) | D3 | livré |
| vue_coupe.svg | 900x500 | svg (schéma technique coté, coupe) | D3 | livré |
| volet_ferme.svg | 900x500 | svg (schéma technique, état fermé) | D3 | livré |
| volet_ouvert.svg | 900x500 | svg (schéma technique, état ouvert) | D3 | livré |

| vue_console.svg | 900x500 | svg (schéma technique coté, plan) | D4 | livré |
| instrument_ecran.svg | 1920x1080 (vectoriel) | svg (fond opaque, texture console) | D4 | livré |
| instrument_cadran.svg | 400x400 (vectoriel) | svg (fond transparent, overlay/texture individuelle) | D4 | livré |
| notes.md (instruments) | — | md | D4 | livré |

## Notes
- Relief/normal Terre : retiré du périmètre D1 (aucune source NASA statique trouvée). Non bloquant pour dev phase 1.
- Planches D2 : schémas techniques cotés (pas de rendu artistique ChatGPT/Codex), décision de session du 2026-07-31.
- Planches D3 : même traitement schéma technique coté que D2, continuité de style.
- D4 : `vue_console.svg` en schéma technique coté (continuité de style), `instrument_ecran.svg`
  et `instrument_cadran.svg` en assets vectoriels directement utilisables (pas de rendu
  ChatGPT/Codex — décision de session du 2026-08-01, cohérente avec D2/D3).
