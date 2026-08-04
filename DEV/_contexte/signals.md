# Signals — dev   (MAJ 2026-08-04)

## Actions ouvertes
- [P1|ouvert] Achever le gate visuel de la phase 4 dans la nouvelle configuration ventrale — volet
  fermé (aucune vue extérieure) et vue Terre au nadir validés par contrôle visuel utilisateur ;
  rotation 360° sans clipping, inversion du volet en cours d'animation, coque visible, absence de
  vitre restent à recontrôler (géométrie déplacée depuis leur dernière vérification). fait quand:
  les 4 points restants de `DEV/tests_manuels.md` validés, phase 4 passée à `[FAIT]` dans
  `roadmap_dev.md`. réf: `DEV/tests_manuels.md`, `DEV/roadmap_dev.md` Phase 4.
- [P1|ouvert] Faire corriger `DESIGN/vaisseau/proportions.md` par la zone design : le document dit
  encore « coupole dessus du fuselage », alors que le code place désormais la coupole/centre de
  commande côté ventral (nadir) — décalage entre la spec et l'implémentation. fait quand: passation
  envoyée à design (`DEV/_handoff.md` + `tools/handoff.py --to design`), document corrigé. réf:
  `DESIGN/vaisseau/proportions.md` § Coupole, `scenes/vaisseau.tscn` (nœuds `Coupole`/
  `CentreCommande`).
- [P1|ouvert] Trancher le conflit coque/cockpit avant d'ouvrir la phase 5 : handoff design D4 exige
  « aucun élément de coque visible dans tout le débattement », `roadmap_dev.md` phase 5 acte
  l'inverse (« voir une partie de la coque est acceptable »). fait quand: une seule formulation
  retenue dans `roadmap_dev.md` Phase 5. réf: `DEV/roadmap_dev.md` Phase 5,
  `DESIGN/vaisseau/proportions.md`.
- [P2|ouvert] Bandeau de voyants (phase 5) sans asset livré par design (dimensionné dans
  `notes.md` mais absent du MANIFEST). fait quand: confirmé que dev le produit en géométrie +
  matériau émissif, ou asset reçu de design. réf: `DESIGN/instruments/notes.md`.
- [P3|ouvert] Compression BPTC (forcée par `project.godot`) appliquée aux SVG d'instruments (traits
  fins 3-5px) : risque d'artefacts de bloc sur la lisibilité. fait quand: contrôlé visuellement à
  l'ouverture de la phase 5, `compress/mode=0` appliqué côté design si besoin. réf:
  `DESIGN/MANIFEST.md`, `project.godot`.
- [P2|ouvert] Handoff dev -> orchestrateur (check_scope.py à corriger, tests_manuels.md par zone).
  fait quand: `tools/check_scope.py` vérifie l'index et non l'arbre de travail, CONVENTIONS.md/
  CLAUDE.md mis à jour. réf: `DEV/_handoff.md`.

## Dernière session (2026-08-04)
Bug remonté au contrôle visuel de la phase 4 : depuis le centre de commande, volet ouvert, la
Terre restait invisible quelle que soit la rotation. Cause identifiée par lecture de
`orbit.gd::frame_at` : `dorsal = zenith` (direction opposée à la Terre) — la coupole, placée
« dessus du fuselage » par `proportions.md`, ouvre donc sur l'espace/zénith, jamais sur la Terre ;
le sol du centre de commande n'était qu'un symptôme (la coque pleine du vaisseau aurait de toute
façon bloqué la vue nadir, coupole ou pas).

Option retenue avec l'utilisateur (écartées : sol vitré translucide — relance le risque de tri de
rendu explicitement évité en phase 1d/4 pour la coupole, et n'aurait probablement pas suffi, la
coque étant directement sous le module ; écran nadir sur moniteur — solution de repli non
choisie) : repositionner la coupole et le centre de commande côté ventral (nadir) plutôt que
dorsal (zenith), à l'image d'une cupola ISS.

Implémentation : `coupole_armature.gd`/`volet_panneaux.gd` construisent toute leur géométrie en
`+Z` local sans référence au monde — le repositionnement se limite à une rotation de 180° autour
de Y sur les nœuds `Coupole` et `CentreCommande` dans `scenes/vaisseau.tscn` (transform
`(-1,0,0, 0,1,0, 0,0,-1)`), aucun script modifié. Réimport (`--import`) sans erreur. Contrôle
visuel utilisateur : Terre visible au nadir, volet ouvert — validé (« c'est parfait »).

`DEV/tests_manuels.md` : point Terre-nadir ajouté puis retiré après validation ; les 4 points du
gate 3 non re-testés dans cette session (rotation fluide, inversion volet, coque visible, absence
de vitre) restent en attente, la géométrie ayant changé de côté depuis leur dernière vérification.

`DESIGN/vaisseau/proportions.md` (« dessus du fuselage ») n'a pas été corrigé — hors périmètre
dev, passation à préparer.
