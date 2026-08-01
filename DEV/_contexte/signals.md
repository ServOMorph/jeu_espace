# Signals — dev   (MAJ 2026-08-01)

## Actions ouvertes
- [P1|ouvert] Trancher le conflit coque/cockpit avant d'ouvrir la phase 5 : handoff design D4 exige « aucun élément de coque visible dans tout le débattement », `roadmap_dev.md` phase 5 acte l'inverse (« voir une partie de la coque est acceptable, ne pas tordre cadrage ni géométrie pour l'éviter ») — fait quand: une seule formulation retenue dans `roadmap_dev.md` Phase 5. réf: `DEV/roadmap_dev.md` Phase 5, `DESIGN/vaisseau/proportions.md`.
- [P1|ouvert] `camera_rig.gd` (phase 4) doit être écrit dans le repère métrique local du vaisseau (`RepereVaisseau`), pas en unités planétaires — pivot architectural décidé en phase 3 (rendu double échelle, deux caméras/deux viewports composités) — fait quand: `camera_rig.gd` s'appuie sur `scripts/core/repere_vaisseau.gd` sans réintroduire d'unités planétaires côté vaisseau. réf: `DEV/roadmap_dev.md` Phase 3 (bloc « Pivot architectural majeur »), `scripts/nodes/vue_orbitale.gd`.
- [P2|ouvert] Bandeau de voyants (phase 5) sans asset livré par design (dimensionné dans `notes.md` mais absent du MANIFEST) — fait quand: confirmé que dev le produit en géométrie + matériau émissif, ou asset reçu de design. réf: `DESIGN/instruments/notes.md`.
- [P3|ouvert] Compression BPTC (forcée par `project.godot`) appliquée aux SVG d'instruments (traits fins 3-5px) : risque d'artefacts de bloc sur la lisibilité — fait quand: contrôlé visuellement à l'ouverture de la phase 5, `compress/mode=0` appliqué côté design si besoin. réf: `DESIGN/MANIFEST.md`, `project.godot`.
- [P2|ouvert] Handoff dev -> orchestrateur (check_scope.py à corriger, tests_manuels.md par zone) — fait quand: `tools/check_scope.py` vérifie l'index et non l'arbre de travail, CONVENTIONS.md/CLAUDE.md mis à jour. réf: `DEV/_handoff.md`.

## Dernière session (2026-08-01)
Phase 2 (horloge de simulation, orbite sur rail) et Phase 3 (vaisseau et hiérarchie de scène)
livrées et closes. Phase 2 : `sim_clock`, `orbit` (`position_at`/`tangent_at`), `sun_direction` ;
bug de pacing corrigé (période de rotation terrestre recalée sur 5400 s, le jour sidéral réel
étant imperceptible même en x60).

Phase 3 : géométrie du vaisseau conforme à `DESIGN/vaisseau/proportions.md` (CSGPolygon3D spin
pour la coque), hiérarchie `Vaisseau`/`Cockpit`/`CentreCommande`. **Pivot architectural majeur** :
un vaisseau à taille réelle (~60 m) est ininterprétable dans le système d'unités planétaire
(1 unité = 100 km) — near plane et précision flottante le rendaient invisible. Rendu repassé en
double échelle : `scenes/monde_lointain.tscn` (planétaire) rendu dans un `SubViewport` composé en
fond, vaisseau fixe à l'origine d'un repère métrique local, caméra lointaine reproduisant le
déplacement orbital (`scripts/nodes/vue_orbitale.gd`, `scripts/core/repere_vaisseau.gd`). Deux
bugs trouvés et corrigés au contrôle visuel (pas en relecture de code) : démarrage côté nuit
(`Orbit.phase_pour_direction` ajouté) et lumière locale jamais éteinte par l'ombre de la Terre
(`Eclairage.facteur_eclipse` ajouté, ombre cylindrique + pénombre). 79/79 tests, couverture 100 %,
gate visuel validé par l'utilisateur. Détail complet dans `DEV/roadmap_dev.md` Phase 3.
