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
- `DOCUMENTATION/` (zone `documentation`) — base de connaissance et cohérence documentaire du
  projet. Contient `systeme_solaire/` (25 fiches d'identité Soleil/planètes/planètes naines/lunes,
  catalogue `INDEX.md`).
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
libre planétaire), retour au menu par F1. Vue Drone corrigée le 2026-08-11 : armature du vaisseau
masquée pendant cette vue (résidu de promotion de caméra Godot) et contrôle souris opérationnel
(relayé depuis l'arbre principal, `LointainViewport` n'ayant pas de `SubViewportContainer`).
Côté zone `design`, phases D0 à D4 closes : charte,
SOURCES.md, MANIFEST.md renseignés, textures Terre/Lune/étoiles livrées, proportions du vaisseau
chiffrées et resynchronisées le 2026-08-11 sur le repositionnement ventral de la coupole,
intérieur/volet et instruments 2D du cockpit livrés. Phase D5 (passe visuelle finale) en cours :
retour `dev` en situation reçu, exposition/contraste/lisibilité nuit validés, halo atmosphérique
corrigé (`shaders/halo.gdshader`).
Zone `documentation` créée : base de connaissance `systeme_solaire/` (25 fiches Soleil/planètes/
planètes naines/lunes, sourcées NASA/JPL/ESA et Wikipédia), lacunes connues documentées dans
`DOCUMENTATION/systeme_solaire/INDEX.md`.
