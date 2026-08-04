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
Côté zone `dev` : Phases 0 à 3 closes, gates validés par contrôle visuel. Phase 4 (centre de
commande, volet de coupole) implémentée côté code — `camera_rig.gd`/`volet_state.gd` (core,
testés), `scenes/centre_commande.tscn`, volet procédural sous `Coupole` dans `vaisseau.tscn` —
97/97 tests, couverture 100 %. Coupole/centre de commande repositionnés côté ventral (nadir) le
2026-08-04 (rotation 180° dans `vaisseau.tscn`) : la Terre, invisible depuis le poste dans la
position dorsale d'origine, est désormais visible et validée par contrôle visuel. Phase non
close : 4 points du gate visuel restent à recontrôler dans cette nouvelle configuration (voir
`DEV/tests_manuels.md`). `DESIGN/vaisseau/proportions.md` désynchronisé (toujours « dessus du
fuselage »), correction à passer côté design. Un conflit entre `roadmap_dev.md` et le handoff D4
sur la visibilité de la coque depuis le cockpit reste aussi à trancher avant la phase 5. Côté zone
`design`, phases D0 à D4 closes : charte, SOURCES.md, MANIFEST.md renseignés, textures
Terre/Lune/étoiles livrées, proportions du vaisseau chiffrées, intérieur/volet et instruments 2D
du cockpit livrés. Phase D5 (passe visuelle finale) bloquée, dépend d'un rendu `dev` en situation.
