# Décisions archivées — dev

Entrées retirées de `contexte.md` (limite 10 entrées) au fil des `/close`, les plus anciennes en
premier ci-dessous.

- 2026-07-31 : Initialisation du protocole vibecoding.
- 2026-07-31 : Tests manuels scindés par zone (`DEV/tests_manuels.md`), pas de fichier partagé racine.
- 2026-07-31 : `check_scope.py` doit vérifier l'index git (`diff --cached`), pas l'arbre de travail — corrigé côté orchestrateur.
- 2026-07-31 : `world_scale.gd` en RefCounted statique (pas d'autoload), pour rester testable sans SceneTree.
- 2026-07-31 : Import textures forcé en BPTC + mipmaps via `project.godot` (DESIGN/textures/ gitignoré, réglages par fichier `.import` non reproductibles).
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
