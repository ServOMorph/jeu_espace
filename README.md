# jeu_espace

## Objectif
Jeu spatial 3D sous Godot : le joueur pilote un vaisseau en orbite terrestre réaliste,
alternant entre le cockpit (vue extérieure sur l'espace) et le centre de commande sous
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
Côté zone `dev` : Phase 0 (fondations Godot) close, gate 3 validé. Phase 1a (géométrie et échelle
de l'environnement spatial, sans shader) close : échelle unique du projet (`world_scale.gd`),
scènes Terre/Lune/Soleil/test_env, tests unitaires, couverture et contrôle visuel gate 1a tous
validés. Phase 1 reste en cours : sous-phase 1b (shader jour/nuit) à traiter en session Opus.
Handoff design D2 (proportions vaisseau) reçu, écarts signalés à trancher avant phase 3. Côté zone
`design`, phases D0, D1 et D2 closes : charte, SOURCES.md, MANIFEST.md renseignés, textures
Terre/Lune/étoiles livrées, proportions du vaisseau chiffrées et planches livrées. Phase D3
(intérieur centre de commande + volet) à démarrer.
