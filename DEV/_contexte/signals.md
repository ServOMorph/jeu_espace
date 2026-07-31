# Signals — dev   (MAJ 2026-07-31)

## Actions ouvertes
- [P1|ouvert] Valider gate 3 phase 0 (lancement fenêtré 1920x1080) — fait quand: contrôle visuel effectué et coché dans `DEV/tests_manuels.md`. réf: `DEV/tests_manuels.md`, `DEV/roadmap_dev.md` Phase 0.
- [P2|ouvert] Traiter le handoff dev -> orchestrateur (check_scope.py à corriger, tests_manuels.md par zone) — fait quand: `tools/check_scope.py` vérifie l'index et non l'arbre de travail, CONVENTIONS.md/CLAUDE.md mis à jour. réf: `DEV/_handoff.md`.
- [P2|ouvert] Vérifier `DESIGN/MANIFEST.md` (albédo jour + fond étoilé) avant de lancer la phase 1. réf: `DEV/roadmap_dev.md` Phase 1.

## Dernière session (2026-07-31)
Phase 0 (fondations Godot) menée à terme : project.godot (Forward+, 1920x1080, input map),
arborescence scripts/core, scripts/nodes, scenes, tests, addons ; GdUnit4 v6.2.0 installé et
validé en headless (`--ignoreHeadlessMode`) ; scène triviale sans erreur. Gates 1 et 2 passés,
gate 3 (contrôle visuel) en attente utilisateur. Défaut découvert : `check_scope.py` lit l'arbre
de travail entier, bloque dès que deux zones ont du travail non commité en parallèle. Arbitré
avec l'utilisateur : correction par vérification de l'index (`git diff --cached`), et
`tests_manuels.md` scindé en un fichier par zone (`DEV/tests_manuels.md`). Handoff envoyé vers
orchestrateur pour la partie hors périmètre dev (tools/, CONVENTIONS.md, CLAUDE.md).
