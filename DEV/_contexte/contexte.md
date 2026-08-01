# Contexte — dev

## Objectif (immuable sauf décision explicite)
Développement du jeu Godot : scripts, scènes, mécaniques de jeu (contrôle vaisseau, physique d'orbite, transitions cockpit/centre de commande).

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4 (3D). Résolution cible MVP : 1920x1080 fenêtré, contrôle caméra à la souris. Deux lieux à scripter : cockpit (vue extérieure sur l'espace devant le vaisseau, vaisseau non visible) et centre de commande sous coupole en verre (vue à 360°, tête tournable, vaisseau visible en mouvement lent comme en orbite réelle). Vaisseau capable d'évoluer en orbite terrestre, d'en sortir ou de redescendre.

## État actuel (réécrit intégralement à chaque /close)
Phases 0 à 3 closes. Phase 4 (centre de commande, volet de coupole) implémentée côté code —
`camera_rig.gd`/`volet_state.gd` (core, testés), `centre_commande.tscn`, volet procédural sous
`Coupole` — 97/97 tests, couverture 100 %, mais gate visuel non encore effectué : phase non close.
Conflit non tranché entre `roadmap_dev.md` phase 5 et handoff D4 sur la visibilité de la coque
depuis le cockpit.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
Entrées antérieures au 2026-08-01 archivées dans `_contexte/archive_decisions.md`.

- 2026-08-01 : `tests_manuels.md` ne doit contenir que des tests exécutables immédiatement (scène existante) — pas d'entrées pour des phases futures non implémentées.
- 2026-08-01 : Gate 1d validé par contrôle visuel utilisateur — phase 1 intégralement close. Halo en glow Fresnel additif `cull_front` (visible en silhouette complète depuis l'extérieur).
- 2026-08-01 : Gate 2 validé — période de rotation propre de la Terre calée sur 5400 s (période orbitale du projet), pas le jour sidéral réel (86164 s, imperceptible même en x60).
- 2026-08-01 : Vaisseau modélisé par assemblage `.tscn`/CSG (pas de générateur `.obj` scripté) — toutes les formes du chiffrage D2 restent dans le répertoire des primitives.
- 2026-08-01 : Rendu passé en double échelle (planétaire pour le lointain, métrique local pour le vaisseau) — un vaisseau à taille réelle est ininterprétable en unités planétaires (near plane, précision flottante). Impacte `camera_rig.gd` en phase 4, cf. `repere_vaisseau.gd`.
- 2026-08-01 : L'assombrissement en orbite vient de l'occultation par la Terre (`Eclairage.facteur_eclipse`), pas de la direction du Soleil qui est fixe — nécessaire pour tout objet en orbite, pas seulement le vaisseau.
- 2026-08-02 : `camera_rig.gd` conçu générique (yaw/pitch paramétrés par des vecteurs `avant`/`haut`), découplé du repère Z-dorsal du vaisseau — réutilisable tel quel en phase 5 (cockpit) avec bornes plus serrées.
- 2026-08-02 : `volet_state.gd` autorise l'inversion en cours d'animation sans saut (repart de la progression courante) — comportement testé explicitement.
- 2026-08-02 : `vue_orbitale.gd` lit `cam_locale.global_transform.orthonormalized()` plutôt que `.transform` — nécessaire dès qu'une caméra de jeu est imbriquée dans la hiérarchie du vaisseau (mise à l'échelle ×60), plus seulement une caméra sœur comme `CameraLibre`.
- 2026-08-02 : Caméra du centre de commande câblée temporairement dans `test_env.tscn` (`VueOrbitale`) pour le gate visuel phase 4, en attendant `lieu_state`/`lieu_manager` (phase 6).
