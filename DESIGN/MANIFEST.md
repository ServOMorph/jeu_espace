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

## Notes
- Relief/normal Terre : retiré du périmètre D1 (aucune source NASA statique trouvée). Non bloquant pour dev phase 1.
- Planches D2 : schémas techniques cotés (pas de rendu artistique ChatGPT/Codex), décision de session du 2026-07-31.
