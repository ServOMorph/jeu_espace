# Contexte — orchestrateur

## Objectif (immuable sauf décision explicite)
Jeu spatial 3D sous Godot : le joueur pilote un vaisseau en orbite terrestre réaliste, alternant entre le cockpit (vue extérieure sur l'espace) et le centre de commande sous coupole (vue à 360°, vaisseau visible). MVP : vaisseau low poly, environnement extérieur réaliste (Terre, soleil, lune, espace).

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4 (3D). Assets 2D générés par ChatGPT via Codex. Résolution cible MVP : 1920x1080 fenêtré, contrôle caméra à la souris. 3 agents prévus : orchestrateur, codeur, design.

## État actuel (réécrit intégralement à chaque /close)
Côté dev : phases 0 à 4 closes (gates validés), phase 5 (cockpit) implémentée côté code — 118/118 tests, couverture 100 % — gate visuel restant à valider. Côté design : phases D0 à D4 closes, D5 (passe visuelle finale) bloquée en attente du gate 5 dev. Renommage complet « Centre de commande » → « Observatoire » effectué (code, scènes, docs), sauf `DESIGN/vaisseau/proportions.md` qui reste désynchronisé sur la position de la coupole (« dessus » au lieu de « ventral »). Outillage de test étoffé : `python run.py` lance un menu à 4 caméras (Vaisseau, Observatoire, Cockpit, Drone) dans `scenes/test_env.tscn`.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026-07-31 : Initialisation du protocole vibecoding (zone racine `orchestrateur`), d'après `_DOCS/idée de base.txt`.
- 2026-07-31 : Roadmap MVP actée (7 phases). Orbite basse ~400 km, pas de pilotage, temps réglable au clavier, volet rétractable sur la coupole, textures NASA réelles, assets dans DESIGN/ (import direct, pas de dossier assets/).
- 2026-07-31 : Zones agents `dev` (DEV/, code Godot) et `design` (DESIGN/, direction artistique) créées, répartition des phases actée dans roadmap_mvp.md.
- 2026-07-31 : Roadmaps de zone + CONVENTIONS.md créés (périmètres, économie de tokens, passation via tools/handoff.py, tests 85% fonctionnel via tools/coverage_check.py, nommage). Textures NASA hors dépôt (tools/fetch_textures.py), phase 1 dev découpée en 1a-1d (shader Terre isolé, session Opus sur 1b), contrainte cockpit/vaisseau invisible levée, coupole sans verre côté intérieur.
- 2026-07-31 : check_scope.py corrigé (index git seul, plus l'arbre de travail entier) suite à un blocage constaté en phase 0 dev. tests_manuels.md confirmé par zone (DEV/, DESIGN/), plus de fichier unique racine.
- 2026-08-11 : Renommage acté « Centre de commande » → « Observatoire » (portée : code, scènes et docs dev/design ; CHANGELOG.md et `_contexte/` laissés intacts, historiques).
- 2026-08-11 : Statuts de `roadmap_mvp.md` resynchronisés avec l'état réel (phases 0-4 [FAIT], 5 [EN COURS]) — n'avaient jamais été mis à jour depuis la création du fichier.
