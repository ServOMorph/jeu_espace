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
Côté zone `dev` : Phase 0 (fondations Godot) close, gate 3 validé. Phase 1 (environnement spatial)
intégralement close : 1a (géométrie/échelle), 1b (shader jour/nuit Terre, `shaders/terre.gdshader`),
1c (couche nuageuse, `shaders/nuages.gdshader`) et 1d (halo atmosphérique, `shaders/halo.gdshader`,
tri de rendu vérifié) — gates tous validés par contrôle visuel. Phase 2 (horloge de simulation,
orbite sur rail) à ouvrir. Handoffs design D2 (vaisseau), D3 (intérieur/volet) et D4 (instruments
cockpit) reçus ; un conflit entre `roadmap_dev.md` et le handoff D4 sur la visibilité de la coque
depuis le cockpit reste à trancher avant la phase 5. Côté zone `design`, phases D0 à D4 closes :
charte, SOURCES.md, MANIFEST.md renseignés, textures Terre/Lune/étoiles livrées, proportions du
vaisseau chiffrées, intérieur/volet et instruments 2D du cockpit livrés. Phase D5 (passe visuelle
finale) bloquée, dépend d'un rendu `dev` en situation.
