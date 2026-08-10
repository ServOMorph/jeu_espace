# jeu_espace

## Objectif
Jeu spatial 3D sous Godot : le joueur pilote un vaisseau en orbite terrestre réaliste,
alternant entre le cockpit (vue extérieure sur l'espace) et l'observatoire sous
coupole (vue à 360°, vaisseau visible). MVP : vaisseau low poly, environnement extérieur
réaliste (Terre, soleil, lune, espace).

## Stack
Godot 4.5 (3D). Assets 2D générés par ChatGPT via Codex. Résolution cible MVP : 1920x1080
fenêtré, contrôle caméra à la souris.

## Structure
- `orchestrateur` (racine) — roadmap, arbitrages, contexte projet.
- `DEV/` (zone `dev`) — scripts, scènes, mécaniques Godot. Voir `DEV/roadmap_dev.md`.
- `DESIGN/` (zone `design`) — direction artistique, assets 2D, textures. Voir `DESIGN/roadmap_design.md`.
- `roadmap_mvp.md` — décisions cadrantes et arbitrages du MVP, 7 phases.
- `CONVENTIONS.md` — règles communes dev/design : périmètres, tests, passation, nommage.
- `tools/` — scripts Python : passation inter-agents, couverture de tests, contrôle de périmètre, téléchargement de textures.
- `run.py` — lance le projet Godot (fenêtré ou `--headless`).

## État actuel
Côté zone `dev` : phases 0 à 4 closes, gates validés par contrôle visuel. Phase 5 (cockpit)
implémentée côté code — bornes de yaw ajoutées à `camera_rig.gd` (réutilisé), `scenes/cockpit.tscn`
livré — 118/118 tests, couverture 100 %. Gate visuel (contrôle manuel) restant à valider, voir
`DEV/tests_manuels.md`. Outillage de test étoffé : `python run.py` lance `scenes/test_env.tscn`
avec un menu de sélection de caméra (Vaisseau en orbite+zoom, Observatoire, Cockpit, Drone en vol
libre planétaire), retour au menu par F1. `DESIGN/vaisseau/proportions.md` reste désynchronisé
(position de la coupole toujours documentée « dessus du fuselage » alors que le code la place côté
ventral depuis le 2026-08-04), correction à passer côté design. Côté zone `design`, phases D0 à D4
closes : charte, SOURCES.md, MANIFEST.md renseignés, textures Terre/Lune/étoiles livrées,
proportions du vaisseau chiffrées, intérieur/volet et instruments 2D du cockpit livrés. Phase D5
(passe visuelle finale) bloquée, dépend d'un rendu `dev` en situation.
