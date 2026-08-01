# Signals — dev   (MAJ 2026-08-01)

## Actions ouvertes
- [P2|ouvert] Traiter le handoff dev -> orchestrateur (check_scope.py à corriger, tests_manuels.md par zone) — fait quand: `tools/check_scope.py` vérifie l'index et non l'arbre de travail, CONVENTIONS.md/CLAUDE.md mis à jour. réf: `DEV/_handoff.md`.
- [P2|ouvert] Trancher les écarts du handoff design D2 (vaisseau) avant d'ouvrir la phase 3 : position des panneaux solaires contradictoire (« à 0.45 L » vs « centrés à 0.45-0.85 L »), statut de `proportions.md` non mis à jour (encore « non validé »), chevauchement coupole/panneaux à vérifier au mesh — fait quand: `DESIGN/vaisseau/proportions.md` corrigé et statut passé à validé. réf: `DESIGN/vaisseau/proportions.md`, `DEV/roadmap_dev.md` Phase 3.
- [P1|ouvert] Sous-phase 1b (shader jour/nuit) à traiter en session Opus, pas Sonnet — fait quand: shader Terre livré et gate 1b validé. réf: `DEV/roadmap_dev.md` Phase 1 (1b), décision 2026-07-31.

## Dernière session (2026-08-01)
Gate 1a validé : contrôle visuel de `test_env.tscn` confirmé par l'utilisateur (courbure, albédo,
mipmaps, fond étoilé, Soleil/terminateur, Lune, absence d'erreur console). Section correspondante
retirée de `DEV/tests_manuels.md`. Phase 1a intégralement close (tests unitaires, couverture,
contrôle visuel). Handoff design D2 (proportions du vaisseau) reçu et revu : test manuel phase 4
(lisibilité de la coque/structures externes entre les montants de l'armature de coupole) ajouté à
`DEV/tests_manuels.md`. Trois écarts relevés dans `proportions.md` et signalés à l'utilisateur, non
résolus (cf. actions ouvertes) — ne bloquent pas la suite immédiate, phase 3 non démarrée. Modèle
basculé sur Sonnet en cours de session : rappel que la sous-phase 1b (shader) exige Opus.
