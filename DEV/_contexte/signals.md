# Signals — dev   (MAJ 2026-08-11)

## Actions ouvertes
- [P2|ouvert] Contrôler visuellement les correctifs de cette session : nuages (dérive lente,
  cohérente avec x1/x10/x60), halo (liseret + diffus, atténuation jour/nuit), vue Drone (armature
  du vaisseau invisible, contrôle souris opérationnel). fait quand: les entrées correspondantes de
  `DEV/tests_manuels.md` validées et supprimées. réf: `DEV/tests_manuels.md`.
- [P1|ouvert] Achever le gate visuel de la phase 4 dans la nouvelle configuration ventrale — volet
  fermé (aucune vue extérieure) et vue Terre au nadir validés par contrôle visuel utilisateur ;
  rotation 360° sans clipping, inversion du volet en cours d'animation, coque visible, absence de
  vitre restent à recontrôler (géométrie déplacée depuis leur dernière vérification). fait quand:
  les 4 points restants de `DEV/tests_manuels.md` validés, phase 4 passée à `[FAIT]` dans
  `roadmap_dev.md`. réf: `DEV/tests_manuels.md`, `DEV/roadmap_dev.md` Phase 4.
- [P1|ouvert] Faire corriger `DESIGN/vaisseau/proportions.md` par la zone design : le document dit
  encore « coupole dessus du fuselage », alors que le code place désormais la coupole/centre de
  commande côté ventral (nadir) — décalage entre la spec et l'implémentation. Une correction est
  présente non commitée dans le working tree au 2026-08-11 (session tierce, hors périmètre de
  cette clôture) : vérifier son état avant de relancer une passation. fait quand: passation
  envoyée à design (`DEV/_handoff.md` + `tools/handoff.py --to design`), document corrigé et
  commité. réf: `DESIGN/vaisseau/proportions.md` § Coupole, `scenes/vaisseau.tscn` (nœuds
  `Coupole`/`CentreCommande`).
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

## Dernière session (2026-08-11)

### Décisions prises
- Nuages recalés sur l'horloge de simulation (bug : tournaient en temps réel, découplés de x1/x10/x60).
- Halo enrichi : double Fresnel (liseret + diffus) et atténuation jour/nuit via `direction_soleil`.
- Vue Drone (outil de test) : armature du vaisseau visible par erreur (résidu de promotion de
  caméra Godot) — corrigé en masquant `Vaisseau` pendant cette vue.
- Vue Drone : souris inopérante (`_input()` jamais appelé sur `CameraDrone`, `LointainViewport`
  sans `SubViewportContainer`) — corrigé par relais explicite depuis `selecteur_camera.gd`.

### Livrables produits ou modifiés
- `shaders/halo.gdshader`, `scripts/nodes/halo.gd`, `scripts/nodes/nuages.gd`,
  `scenes/halo.tscn`, `scenes/monde_lointain.tscn` : livrés, déjà commités (615c557).
- `scripts/nodes/camera_drone.gd`, `scripts/nodes/selecteur_camera.gd`, `scenes/test_env.tscn`,
  `DEV/tests_manuels.md` : livrés, à committer par cette clôture.

### Hypothèses validées / invalidées
- VALIDE : 118/118 tests unitaires après chaque correctif, aucune régression.
- EN ATTENTE : contrôle visuel utilisateur des 4 correctifs (aucun testé en jeu cette session).

### Prochaine étape exacte
Contrôle visuel des entrées ajoutées à `DEV/tests_manuels.md` (halo, nuages, vue Drone armature,
vue Drone souris).

### Question bloquante pour la session suivante
Aucune
