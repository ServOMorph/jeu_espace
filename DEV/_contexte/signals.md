# Signals — dev   (MAJ 2026-07-31)

## Actions ouvertes
- [P1|ouvert] Valider gate 1a phase 1 (contrôle visuel test_env.tscn) — fait quand: critères de `DEV/tests_manuels.md` cochés. réf: `DEV/tests_manuels.md`, `DEV/roadmap_dev.md` Phase 1 (1a).
- [P2|ouvert] Traiter le handoff dev -> orchestrateur (check_scope.py à corriger, tests_manuels.md par zone) — fait quand: `tools/check_scope.py` vérifie l'index et non l'arbre de travail, CONVENTIONS.md/CLAUDE.md mis à jour. réf: `DEV/_handoff.md`.

## Dernière session (2026-07-31)
Phase 0 close : gate 3 (lancement fenêtré 1920x1080) validé par l'utilisateur. Phase 1a
(géométrie et échelle, sans shader) livrée : `scripts/core/world_scale.gd` (échelle unique du
projet, 1 unité = 100 km, RefCounted statique — pas d'autoload pour rester testable sans
SceneTree), 14 tests unitaires passés, couverture 100%. Scènes `terre.tscn`, `lune.tscn`,
`soleil.tscn`, `test_env.tscn` créées, câblage nœuds sans logique. Import des textures NASA
reconfiguré (`project.godot` [importer_defaults]) : compression BPTC + mipmaps, VRAM albédo Terre
939 Mo -> 354 Mo, scintillement évité. Hypothèse de blocage GPU sur la résolution 21600x10800
testée et invalidée (OK sur RTX 4060). Piège découvert et documenté dans `roadmap_dev.md` :
GdUnit4 crashe (signal 11) si un `class_name` n'a pas été enregistré via `--import` avant les
tests. Gate 1a : tests unitaires et couverture validés, contrôle visuel restant.
