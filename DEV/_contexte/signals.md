# Signals — dev   (MAJ 2026-08-01)

## Actions ouvertes
- [P1|ouvert] Trancher le conflit coque/cockpit avant d'ouvrir la phase 5 : handoff design D4 exige « aucun élément de coque visible dans tout le débattement », `roadmap_dev.md` phase 5 acte l'inverse (« voir une partie de la coque est acceptable, ne pas tordre cadrage ni géométrie pour l'éviter ») — fait quand: une seule formulation retenue dans `roadmap_dev.md` Phase 5 (le suivi détaillé n'est plus dans `tests_manuels.md`, cf. décision du jour). réf: `DEV/roadmap_dev.md` Phase 5, `DESIGN/vaisseau/proportions.md`.
- [P2|ouvert] Chevauchement coupole/panneaux solaires à vérifier au mesh en phase 3 (coupole 0.40-0.70 L, panneaux à 0.45 L) — fait quand: vérifié visuellement sur le mesh assemblé. réf: `DESIGN/vaisseau/proportions.md`, `DEV/roadmap_dev.md` Phase 3.
- [P2|ouvert] Bandeau de voyants (phase 5) sans asset livré par design (dimensionné dans `notes.md` mais absent du MANIFEST) — fait quand: confirmé que dev le produit en géométrie + matériau émissif, ou asset reçu de design. réf: `DESIGN/instruments/notes.md`.
- [P3|ouvert] Compression BPTC (forcée par `project.godot`) appliquée aux SVG d'instruments (traits fins 3-5px) : risque d'artefacts de bloc sur la lisibilité — fait quand: contrôlé visuellement à l'ouverture de la phase 5, `compress/mode=0` appliqué côté design si besoin. réf: `DESIGN/MANIFEST.md`, `project.godot`.
- [P2|ouvert] Handoff dev -> orchestrateur (check_scope.py à corriger, tests_manuels.md par zone) — fait quand: `tools/check_scope.py` vérifie l'index et non l'arbre de travail, CONVENTIONS.md/CLAUDE.md mis à jour. réf: `DEV/_handoff.md`.

## Dernière session (2026-08-01)
Sous-phase 1c (couche nuageuse) livrée et gate validé par contrôle visuel utilisateur : constante
`ALTITUDE_NUAGES_KM` + `rayon_nuages_unites()` ajoutées à `scripts/core/world_scale.gd` (2 tests),
shader `shaders/nuages.gdshader` (alpha depuis le masque de gris `terre_clouds_2048x1024.jpg` livré
par design), `scripts/nodes/nuages.gd` (rotation propre lente), `scenes/nuages.tscn`, câblée dans
`scenes/test_env.tscn`. 27/27 tests passent. Phase 1a+1b+1c closes ; reste 1d (halo + tri de rendu)
avant clôture phase 1. Correction de fonctionnement demandée par l'utilisateur : `DEV/tests_manuels.md`
ne doit plus contenir d'entrées pour des phases futures non implémentées (scène inexistante = rien à
valider) — les 3 entrées phase 4/5 prématurément ajoutées ont été retirées, à réintroduire à
l'ouverture de ces phases avec la commande de lancement associée. Fichier vidé, pas de test manuel en
attente actuellement.
