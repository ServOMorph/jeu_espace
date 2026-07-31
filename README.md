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

## État actuel
Roadmap MVP (7 phases) déclinée en roadmaps de zone et conventions communes. Outillage Python
en place. Phase 0 (fondations Godot) prête à démarrer côté zone `dev`. Aucun code produit.
