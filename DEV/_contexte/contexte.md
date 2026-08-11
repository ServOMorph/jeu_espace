# Contexte — dev

## Objectif (immuable sauf décision explicite)
Développement du jeu Godot : scripts, scènes, mécaniques de jeu (contrôle vaisseau, physique d'orbite, transitions cockpit/centre de commande).

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4 (3D). Résolution cible MVP : 1920x1080 fenêtré, contrôle caméra à la souris. Deux lieux à scripter : cockpit (vue extérieure sur l'espace devant le vaisseau, vaisseau non visible) et centre de commande sous coupole en verre (vue à 360°, tête tournable, vaisseau visible en mouvement lent comme en orbite réelle). Vaisseau capable d'évoluer en orbite terrestre, d'en sortir ou de redescendre.

## État actuel (réécrit intégralement à chaque /close)
Phases 0 à 4 closes. Phase 5 (cockpit) : gates 1 et 2 validés (127/127 tests, couverture 100 %),
gate 3 (contrôle visuel) en attente (`DEV/tests_manuels.md`). Tableau de bord du cockpit
implémenté cette session sur un plan pivoté en cours de route : vue extérieure (baie vitrée
existante) + rangée de 3 écrans, écran 1 = carte Terre/Lune/Soleil en direct, écrans 2/3 =
placeholders. Instruments existants (cadrans, bandeau, ancien écran central) conservés. Conflit
coque/cockpit et correction de `DESIGN/vaisseau/proportions.md` : constatés résolus en début de
session (roadmap_mvp.md et commit design dc9884a). Nuages/halo/vue Drone (session précédente,
2026-08-11) : correctifs livrés, contrôle visuel toujours en attente.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
Entrées antérieures au 2026-08-02 (et gates 1a/1b/1d/2/vaisseau CSG) archivées dans
`_contexte/archive_decisions.md`.

- 2026-08-02 : `camera_rig.gd` conçu générique (yaw/pitch paramétrés par des vecteurs `avant`/`haut`), découplé du repère Z-dorsal du vaisseau — réutilisable tel quel en phase 5 (cockpit) avec bornes plus serrées.
- 2026-08-02 : `volet_state.gd` autorise l'inversion en cours d'animation sans saut (repart de la progression courante) — comportement testé explicitement.
- 2026-08-02 : `vue_orbitale.gd` lit `cam_locale.global_transform.orthonormalized()` plutôt que `.transform` — nécessaire dès qu'une caméra de jeu est imbriquée dans la hiérarchie du vaisseau (mise à l'échelle ×60), plus seulement une caméra sœur comme `CameraLibre`.
- 2026-08-02 : Caméra du centre de commande câblée temporairement dans `test_env.tscn` (`VueOrbitale`) pour le gate visuel phase 4, en attendant `lieu_state`/`lieu_manager` (phase 6).
- 2026-08-04 : `orbit.gd::frame_at` fixe `dorsal = zenith` (opposé à la Terre) — une coupole côté dorsal ne peut jamais donner vue sur la Terre, quelle que soit la géométrie du sol. Coupole/centre de commande déplacés côté ventral (nadir) dans `vaisseau.tscn` pour corriger.
- 2026-08-04 : Sol vitré/translucide écarté comme solution — relance le risque de tri de rendu évité en phase 1d/4, et la coque pleine du vaisseau aurait de toute façon bloqué la vue nadir depuis la position dorsale d'origine.
- 2026-08-11 : Nuages recalés sur l'horloge de simulation (tournaient en temps réel via `_process(delta)`, découplés de x1/x10/x60) ; halo enrichi (double Fresnel liseret+diffus, atténuation jour/nuit via `direction_soleil` poussée comme dans `terre.gd`).
- 2026-08-11 : Vue Drone — deux bugs distincts corrigés. Armature du vaisseau visible : Godot promeut automatiquement une autre caméra du même monde quand la courante est désactivée ; `Vaisseau` masqué en vue Drone pour neutraliser ce résidu. Souris inopérante : `LointainViewport` n'a pas de `SubViewportContainer` (`handle_input_locally=false`), donc `_input()` n'y est jamais appelé sur `CameraDrone` ; relayé depuis `selecteur_camera.gd` (arbre principal).
- 2026-08-11 : Tableau de bord cockpit — carte MAP en affichage permanent (pas de clic/overlay, plan fourni par l'utilisateur en cours de session) plutôt que l'overlay plein cadre initialement demandé. `CockpitMap` (projection azimutale équidistante) conservé, mécanisme de ciblage par angle regard/caméra abandonné avec le clic.
