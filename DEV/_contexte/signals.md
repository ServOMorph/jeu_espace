# Signals — dev   (MAJ 2026-08-01)

## Actions ouvertes
- [P1|ouvert] Trancher le conflit coque/cockpit avant d'ouvrir la phase 5 : handoff design D4 exige « aucun élément de coque visible dans tout le débattement », `roadmap_dev.md` phase 5 acte l'inverse (« voir une partie de la coque est acceptable, ne pas tordre cadrage ni géométrie pour l'éviter ») — fait quand: une seule formulation retenue dans `DEV/tests_manuels.md` et `roadmap_dev.md` Phase 5. réf: `DEV/tests_manuels.md` section « Visibilité de la coque depuis le cockpit », `DEV/roadmap_dev.md` Phase 5.
- [P2|ouvert] Chevauchement coupole/panneaux solaires à vérifier au mesh en phase 3 (coupole 0.40-0.70 L, panneaux à 0.45 L) — fait quand: vérifié visuellement sur le mesh assemblé. réf: `DESIGN/vaisseau/proportions.md`, `DEV/roadmap_dev.md` Phase 3.
- [P2|ouvert] Bandeau de voyants (phase 5) sans asset livré par design (dimensionné dans `notes.md` mais absent du MANIFEST) — fait quand: confirmé que dev le produit en géométrie + matériau émissif, ou asset reçu de design. réf: `DESIGN/instruments/notes.md`.
- [P3|ouvert] Compression BPTC (forcée par `project.godot`) appliquée aux SVG d'instruments (traits fins 3-5px) : risque d'artefacts de bloc sur la lisibilité — fait quand: contrôlé visuellement en phase 5, `compress/mode=0` appliqué côté design si besoin. réf: `DEV/tests_manuels.md` section phase 5 instruments.
- [P2|ouvert] Handoff dev -> orchestrateur (check_scope.py à corriger, tests_manuels.md par zone) — fait quand: `tools/check_scope.py` vérifie l'index et non l'arbre de travail, CONVENTIONS.md/CLAUDE.md mis à jour. réf: `DEV/_handoff.md`.

## Dernière session (2026-08-01)
Sous-phase 1b (shader jour/nuit) livrée et gate validé par contrôle visuel utilisateur : shader
`shaders/terre.gdshader` (mélange jour/nuit par incidence, EMISSION pour lumières nocturnes),
logique dupliquée en pur GDScript testable dans `scripts/core/eclairage.gd` (11 tests). Terre
câblée en ShaderMaterial, direction Soleil poussée depuis `scenes/test_env.tscn`. Phase 1a+1b
closes ; reste 1c (nuages) et 1d (halo) avant clôture phase 1. Nouveau dossier racine `shaders/`
acté (hors arborescence phase 0 initiale). Correction d'une erreur de ma part en amont de session :
la synthèse de `signals.md` sur `proportions.md` (panneaux contradictoires, statut non validé)
était périmée — relecture directe a montré un fichier déjà cohérent, seul le chevauchement
coupole/panneaux reste à vérifier au mesh. Handoff design D4 (instruments cockpit) reçu et traité :
livrables vérifiés sur disque, 2 tests manuels ajoutés à `DEV/tests_manuels.md`, dont un conflit
non tranché avec `roadmap_dev.md` sur la visibilité de la coque depuis le cockpit (nouvelle action
ouverte P1).
