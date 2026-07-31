# Contexte — orchestrateur

## Objectif (immuable sauf décision explicite)
Jeu spatial 3D sous Godot : le joueur pilote un vaisseau en orbite terrestre réaliste, alternant entre le cockpit (vue extérieure sur l'espace) et le centre de commande sous coupole (vue à 360°, vaisseau visible). MVP : vaisseau low poly, environnement extérieur réaliste (Terre, soleil, lune, espace).

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4 (3D). Assets 2D générés par ChatGPT via Codex. Résolution cible MVP : 1920x1080 fenêtré, contrôle caméra à la souris. 3 agents prévus : orchestrateur, codeur, design.

## État actuel (réécrit intégralement à chaque /close)
Phase 0 dev quasi close : gate 3 (fenêtré 1920x1080, sans erreur) validé visuellement par l'utilisateur, reste à cocher dans DEV/tests_manuels.md via une session dev. Design D0 pas encore démarré. Correctifs de protocole appliqués : check_scope.py vérifie l'index git (pas l'arbre de travail entier), tests_manuels.md confirmé par zone. run.py ajouté à la racine pour lancer le projet Godot.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026-07-31 : Initialisation du protocole vibecoding (zone racine `orchestrateur`), d'après `_DOCS/idée de base.txt`.
- 2026-07-31 : Roadmap MVP actée (7 phases). Orbite basse ~400 km, pas de pilotage, temps réglable au clavier, volet rétractable sur la coupole, textures NASA réelles, assets dans DESIGN/ (import direct, pas de dossier assets/).
- 2026-07-31 : Zones agents `dev` (DEV/, code Godot) et `design` (DESIGN/, direction artistique) créées, répartition des phases actée dans roadmap_mvp.md.
- 2026-07-31 : Roadmaps de zone + CONVENTIONS.md créés (périmètres, économie de tokens, passation via tools/handoff.py, tests 85% fonctionnel via tools/coverage_check.py, nommage). Textures NASA hors dépôt (tools/fetch_textures.py), phase 1 dev découpée en 1a-1d (shader Terre isolé, session Opus sur 1b), contrainte cockpit/vaisseau invisible levée, coupole sans verre côté intérieur.
- 2026-07-31 : check_scope.py corrigé (index git seul, plus l'arbre de travail entier) suite à un blocage constaté en phase 0 dev. tests_manuels.md confirmé par zone (DEV/, DESIGN/), plus de fichier unique racine.
