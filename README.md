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
- `DEV/` (zone `dev`) — scripts, scènes, mécaniques Godot.
- `DESIGN/` (zone `design`) — direction artistique, assets 2D, textures.
- `roadmap_mvp.md` — roadmap détaillée du MVP, 7 phases.

## État actuel
Roadmap MVP définie (7 phases). Phase 0 (fondations Godot) prête à démarrer côté zone `dev`.
Aucun code produit. Zones agents `dev` et `design` créées et opérationnelles.
