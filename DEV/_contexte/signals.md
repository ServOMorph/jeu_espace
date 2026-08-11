# Signals — dev   (MAJ 2026-08-11)

## Actions ouvertes
- [P2|ouvert] Contrôler visuellement les correctifs de la session précédente : nuages (dérive
  lente, cohérente avec x1/x10/x60), halo (liseret + diffus, atténuation jour/nuit), vue Drone
  (armature du vaisseau invisible, contrôle souris opérationnel). fait quand: les entrées
  correspondantes de `DEV/tests_manuels.md` validées et supprimées. réf: `DEV/tests_manuels.md`.
- [P1|ouvert] Achever le gate visuel de la phase 4 dans la configuration ventrale — volet fermé
  et vue Terre au nadir validés par contrôle visuel utilisateur (2026-08-04) ; rotation 360° sans
  clipping, inversion du volet en cours d'animation, coque visible, absence de vitre restent à
  recontrôler (signalé comme géométrie potentiellement déplacée depuis leur dernière
  vérification — non revérifié cette session, aucun changement identifié dans `scenes/
  vaisseau.tscn` depuis le 2026-08-04 mais la prudence du signal précédent est conservée). fait
  quand: les 4 points restants de `DEV/tests_manuels.md` validés, phase 4 repassée en revue dans
  `roadmap_dev.md`. réf: `DEV/tests_manuels.md`, `DEV/roadmap_dev.md` Phase 4.
- [P2|ouvert] Compression BPTC (forcée par `project.godot`) appliquée aux SVG d'instruments
  (traits fins 3-5px) : risque d'artefacts de bloc sur la lisibilité. fait quand: contrôlé
  visuellement à l'ouverture du gate 3 de la phase 5, `compress/mode=0` appliqué côté design si
  besoin. réf: `DESIGN/MANIFEST.md`, `project.godot`.
- [P1|ouvert] Gate 3 (contrôle visuel) de la phase 5 (cockpit) en attente, tableau de bord
  reconstruit cette session sur un nouveau plan (voir Dernière session). fait quand: entrée
  correspondante de `DEV/tests_manuels.md` validée, phase 5 passée à `[FAIT]` dans
  `roadmap_dev.md`. réf: `DEV/tests_manuels.md`, `DEV/roadmap_dev.md` Phase 5.
- [P2|ouvert] Handoff dev -> orchestrateur : `check_scope.py` à corriger (index vs arbre de
  travail, `tests_manuels.md` par zone) + nouveau point constaté cette session : `SCOPES["dev"]`
  n'inclut pas `README.md`/`CHANGELOG.md` alors que le `/close` générique demande de les modifier
  à chaque clôture — contradiction avec l'invariant strict de `DEV/agent_role.md`. Cette clôture
  n'a donc pas touché `README.md`/`CHANGELOG.md`. fait quand: `tools/check_scope.py` corrigé,
  arbitrage explicite sur le périmètre README/CHANGELOG, `CONVENTIONS.md`/`CLAUDE.md` mis à jour.
  réf: `DEV/_handoff.md`.

## Dernière session (2026-08-11)

### Décisions prises
- Tableau de bord du cockpit (phase 5, ajout de périmètre orchestrateur) implémenté en deux
  passes : une première version (deux écrans IA/MAP, clic pour ouvrir un overlay plein cadre)
  a été abandonnée en cours de session sur nouveau plan fourni par l'utilisateur.
- Plan retenu : vue extérieure (baie vitrée existante, inchangée) en haut, rangée de 3 écrans en
  dessous. Écran 1 affiche la carte Terre/Lune/Soleil en permanence (plus de clic/overlay).
  Écrans 2 et 3 sont des placeholders statiques, contenu à définir plus tard. Instruments
  existants (cadrans, bandeau, ancien écran central) conservés tels quels.
- Détection au clic initialement retenue (angle regard/cible, `CiblageEcran`) devenue inutile
  après le pivot vers un affichage permanent — module retiré avec le reste du mécanisme
  d'overlay (`cockpit_interaction.gd`, `reticule_cockpit.gd`, `carte_overlay.gd`).
- `DESIGN/vaisseau/proportions.md` (conflit « dessus »/nadir) et le conflit coque/cockpit
  (handoff D4 vs roadmap phase 5) : constatés résolus en relisant `roadmap_mvp.md` et le commit
  `dc9884a` en tout début de session — retirés des actions ouvertes.
- Bandeau de voyants du cockpit : constaté déjà produit par dev en géométrie + matériau émissif
  (`mesh_bandeau`/`mat_bandeau` dans `scenes/cockpit.tscn`) — retiré des actions ouvertes.
- README.md/CHANGELOG.md à la racine non modifiés par cette clôture dev (cf. action ouverte
  ci-dessus sur le désaccord `check_scope.py`/invariant de zone).

### Livrables produits ou modifiés
- `scripts/core/cockpit_map.gd` : projection azimutale équidistante Terre/Lune/Soleil, testé
  (9 tests).
- `scripts/nodes/ecran_holo.gd`/`ecran_holo_3d.gd` + `scenes/ecran_holo.tscn` : écran procédural
  réutilisable (SubViewport → texture → quad émissif), sert aux placeholders Écran 2/3.
- `scripts/nodes/carte_contenu.gd`, `carte_map_driver.gd` + `scenes/ecran_map_3d.tscn` : Écran 1,
  disque radar mis à jour en continu depuis `orbit.gd`/`sun_direction.gd`.
- `scenes/cockpit.tscn` : rangée Écran1/2/3 ajoutée, console approfondie pour loger la nouvelle
  rangée sans chevaucher le bandeau existant.
- `scenes/test_env.tscn` : câblage de `CarteMapDriver`.
- `DEV/tests_manuels.md` : entrée mise à jour pour le tableau de bord (contenu du plan final).
- `DEV/roadmap_dev.md` Phase 5 : bloc « Ajout de périmètre » complété d'un bloc « Pivot »
  documentant le changement de plan et l'état livré.
- `DEV/_handoff.md` : section 3 ajoutée (désaccord `check_scope.py` sur README/CHANGELOG).
- Retiré : `scripts/core/ciblage_ecran.gd`, `scripts/nodes/cockpit_interaction.gd`,
  `scripts/nodes/reticule_cockpit.gd`, `scripts/nodes/carte_overlay.gd`,
  `scenes/carte_overlay.tscn` (mécanisme clic/overlay abandonné en cours de session).

### Hypothèses validées / invalidées
- VALIDE : 127/127 tests unitaires, couverture `scripts/core/` 100 % après le pivot.
- INVALIDE : premier plan (2 écrans IA/MAP + clic/overlay) -> pivot vers affichage permanent sur
  un plan à 3 écrans fourni par l'utilisateur, en cours de session.
- EN ATTENTE : contrôle visuel utilisateur du tableau de bord (disposition géométrique de la
  nouvelle rangée non vérifiée à l'œil, seulement calculée par angle depuis la caméra).

### Prochaine étape exacte
Contrôle visuel du tableau de bord (`python run.py`, Cockpit) : lisibilité des 3 écrans, disque
radar de l'écran 1 cohérent avec l'orbite en accéléré, aucun écran hors du débattement caméra.
Entrée déjà prête dans `DEV/tests_manuels.md`.

### Question bloquante pour la session suivante
Arbitrage à demander à l'orchestrateur sur le désaccord `check_scope.py`/README-CHANGELOG (cf.
`DEV/_handoff.md` section 3) — sans quoi chaque `/close` dev devra continuer à choisir entre
suivre le template générique ou l'invariant de zone.
