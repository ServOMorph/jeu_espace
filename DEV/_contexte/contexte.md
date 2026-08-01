# Contexte — dev

## Objectif (immuable sauf décision explicite)
Développement du jeu Godot : scripts, scènes, mécaniques de jeu (contrôle vaisseau, physique d'orbite, transitions cockpit/centre de commande).

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4 (3D). Résolution cible MVP : 1920x1080 fenêtré, contrôle caméra à la souris. Deux lieux à scripter : cockpit (vue extérieure sur l'espace devant le vaisseau, vaisseau non visible) et centre de commande sous coupole en verre (vue à 360°, tête tournable, vaisseau visible en mouvement lent comme en orbite réelle). Vaisseau capable d'évoluer en orbite terrestre, d'en sortir ou de redescendre.

## État actuel (réécrit intégralement à chaque /close)
Phases 0 à 3 closes, gates tous validés par contrôle visuel. Phase 2 : horloge de simulation,
orbite sur rail (`sim_clock`, `orbit`, `sun_direction`). Phase 3 : vaisseau modélisé et rendu en
orbite, cycle jour/nuit correct (occultation par la Terre, pas seulement direction du Soleil).
Rendu passé en double échelle (planétaire pour le lointain, métrique local pour le vaisseau,
cf. `scripts/core/repere_vaisseau.gd`) — impacte directement l'écriture de `camera_rig.gd` en
phase 4. Phase 4 (centre de commande, volet de coupole) à ouvrir. Conflit non tranché entre
`roadmap_dev.md` phase 5 et handoff D4 sur la visibilité de la coque depuis le cockpit.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
Entrées antérieures au 2026-08-01 archivées dans `_contexte/archive_decisions.md`.

- 2026-08-01 : Gate 1a validé par contrôle visuel utilisateur — phase 1a intégralement close.
- 2026-08-01 : Dossier racine `shaders/` ajouté (hors arborescence phase 0 initiale) pour les `.gdshader`.
- 2026-08-01 : Shader Terre sans normal map (retirée du périmètre D1) ; logique jour/nuit dupliquée en GDScript pur pour rester testable, à synchroniser manuellement avec le shader.
- 2026-08-01 : Gate 1b validé par contrôle visuel utilisateur — phase 1b close.
- 2026-08-01 : `tests_manuels.md` ne doit contenir que des tests exécutables immédiatement (scène existante) — pas d'entrées pour des phases futures non implémentées.
- 2026-08-01 : Gate 1d validé par contrôle visuel utilisateur — phase 1 intégralement close. Halo en glow Fresnel additif `cull_front` (visible en silhouette complète depuis l'extérieur).
- 2026-08-01 : Gate 2 validé — période de rotation propre de la Terre calée sur 5400 s (période orbitale du projet), pas le jour sidéral réel (86164 s, imperceptible même en x60).
- 2026-08-01 : Vaisseau modélisé par assemblage `.tscn`/CSG (pas de générateur `.obj` scripté) — toutes les formes du chiffrage D2 restent dans le répertoire des primitives.
- 2026-08-01 : Rendu passé en double échelle (planétaire pour le lointain, métrique local pour le vaisseau) — un vaisseau à taille réelle est ininterprétable en unités planétaires (near plane, précision flottante). Impacte `camera_rig.gd` en phase 4, cf. `repere_vaisseau.gd`.
- 2026-08-01 : L'assombrissement en orbite vient de l'occultation par la Terre (`Eclairage.facteur_eclipse`), pas de la direction du Soleil qui est fixe — nécessaire pour tout objet en orbite, pas seulement le vaisseau.
