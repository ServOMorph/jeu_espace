# Signals — dev   (MAJ 2026-08-02)

## Actions ouvertes
- [P1|ouvert] Valider le gate visuel de la phase 4 (centre de commande, volet de coupole) — code livré et testé (97/97, couverture 100 %), contrôle visuel utilisateur non encore effectué — fait quand: les 6 points de `DEV/tests_manuels.md` validés, phase 4 passée à `[FAIT]` dans `roadmap_dev.md`. réf: `DEV/tests_manuels.md`, `DEV/roadmap_dev.md` Phase 4.
- [P1|ouvert] Trancher le conflit coque/cockpit avant d'ouvrir la phase 5 : handoff design D4 exige « aucun élément de coque visible dans tout le débattement », `roadmap_dev.md` phase 5 acte l'inverse (« voir une partie de la coque est acceptable, ne pas tordre cadrage ni géométrie pour l'éviter ») — fait quand: une seule formulation retenue dans `roadmap_dev.md` Phase 5. réf: `DEV/roadmap_dev.md` Phase 5, `DESIGN/vaisseau/proportions.md`.
- [P2|ouvert] Bandeau de voyants (phase 5) sans asset livré par design (dimensionné dans `notes.md` mais absent du MANIFEST) — fait quand: confirmé que dev le produit en géométrie + matériau émissif, ou asset reçu de design. réf: `DESIGN/instruments/notes.md`.
- [P3|ouvert] Compression BPTC (forcée par `project.godot`) appliquée aux SVG d'instruments (traits fins 3-5px) : risque d'artefacts de bloc sur la lisibilité — fait quand: contrôlé visuellement à l'ouverture de la phase 5, `compress/mode=0` appliqué côté design si besoin. réf: `DESIGN/MANIFEST.md`, `project.godot`.
- [P2|ouvert] Handoff dev -> orchestrateur (check_scope.py à corriger, tests_manuels.md par zone) — fait quand: `tools/check_scope.py` vérifie l'index et non l'arbre de travail, CONVENTIONS.md/CLAUDE.md mis à jour. réf: `DEV/_handoff.md`.

## Dernière session (2026-08-02)
Phase 4 (centre de commande et volet de coupole) implémentée côté code, non close — gate visuel
en attente. `scripts/core/camera_rig.gd` : état pur yaw/pitch paramétré par des vecteurs
`avant`/`haut`, découplé du repère Z-dorsal du vaisseau, réutilisable en phase 5. 8 tests.
`scripts/core/volet_state.gd` : machine à états fermé/ouverture/ouvert/fermeture, inversion en
cours d'animation sans saut. 10 tests. `scripts/nodes/volet_panneaux.gd` génère les 12 panneaux
proceduralement à partir des constantes de `CoupoleArmature` (désormais `class_name` pour être
partagée). `scenes/centre_commande.tscn` créée et instanciée sous `CentreCommande` dans
`vaisseau.tscn` ; `Volet` ajouté sous `Coupole`.

Correction nécessaire dans `vue_orbitale.gd` : la caméra du centre de commande est la première
caméra de jeu imbriquée dans la hiérarchie du vaisseau (mise à l'échelle ×60 en `_ready`) — lire
`cam_locale.transform` (local à l'immédiat parent) comme le faisait le code d'origine ignorait
cette échelle et l'offset de `CentreCommande`. Corrigé en lisant
`cam_locale.global_transform.orthonormalized()`. Caméra câblée temporairement dans
`test_env.tscn` pour le contrôle visuel (décision utilisateur), en l'absence de
`lieu_state`/`lieu_manager` (phase 6) — voir `DEV/roadmap_dev.md` Phase 4, bloc « État ».

97/97 tests, couverture fonctionnelle 100 %, import et chargement de scène sans erreur.

Règle ajoutée (hors périmètre dev strict, mais appliquée ici) : toute entrée de
`tests_manuels.md` doit inclure la commande de lancement du contrôle, et toute modification de
`.claude/CLAUDE.md` doit être proposée en synchronisation dans `AGENTS.md`/`GEMINI.md` (et
inversement) — `GEMINI.md` créé ce jour, absent jusqu'ici.
