# Contexte — dev

## Objectif (immuable sauf décision explicite)
Développement du jeu Godot : scripts, scènes, mécaniques de jeu (contrôle vaisseau, physique d'orbite, transitions cockpit/centre de commande).

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4 (3D). Résolution cible MVP : 1920x1080 fenêtré, contrôle caméra à la souris. Deux lieux à scripter : cockpit (vue extérieure sur l'espace devant le vaisseau, vaisseau non visible) et centre de commande sous coupole en verre (vue à 360°, tête tournable, vaisseau visible en mouvement lent comme en orbite réelle). Vaisseau capable d'évoluer en orbite terrestre, d'en sortir ou de redescendre.

## État actuel (réécrit intégralement à chaque /close)
Phase 0 close (gate 3 validé). Phase 1 EN COURS : 1a close (échelle/géométrie) et 1b close
(shader jour/nuit `shaders/terre.gdshader` + `scripts/core/eclairage.gd`, gate validé par
contrôle visuel 2026-08-01). Restent 1c (nuages) et 1d (halo + tri de rendu). Handoffs design D2
(vaisseau), D3 (intérieur/volet) et D4 (instruments cockpit) reçus. Conflit non tranché entre
`roadmap_dev.md` phase 5 et handoff D4 sur la visibilité de la coque depuis le cockpit.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026-07-31 : Initialisation du protocole vibecoding.
- 2026-07-31 : Tests manuels scindés par zone (`DEV/tests_manuels.md`), pas de fichier partagé racine.
- 2026-07-31 : `check_scope.py` doit vérifier l'index git (`diff --cached`), pas l'arbre de travail — corrigé côté orchestrateur.
- 2026-07-31 : `world_scale.gd` en RefCounted statique (pas d'autoload), pour rester testable sans SceneTree.
- 2026-07-31 : Import textures forcé en BPTC + mipmaps via `project.godot` (DESIGN/textures/ gitignoré, réglages par fichier `.import` non reproductibles).
- 2026-08-01 : Gate 1a validé par contrôle visuel utilisateur — phase 1a intégralement close.
- 2026-08-01 : Dossier racine `shaders/` ajouté (hors arborescence phase 0 initiale) pour les `.gdshader`.
- 2026-08-01 : Shader Terre sans normal map (retirée du périmètre D1) ; logique jour/nuit dupliquée en GDScript pur pour rester testable, à synchroniser manuellement avec le shader.
- 2026-08-01 : Gate 1b validé par contrôle visuel utilisateur — phase 1b close.
