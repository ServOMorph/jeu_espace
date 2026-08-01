## v0.10 — 2026-08-01

### Ajouté
- shaders/terre.gdshader : shader jour/nuit de la Terre (albédo diurne, lumières urbaines en
  émission côté nuit), gate 1b validé par contrôle visuel.
- scripts/core/eclairage.gd : logique jour/nuit pure et testable, miroir du shader ; 11 tests
  unitaires (tests/test_eclairage.gd).

### Modifié
- scenes/terre.tscn, scripts/nodes/terre.gd, scenes/test_env.tscn : Terre câblée en
  ShaderMaterial, direction du Soleil poussée depuis le nœud Soleil.
- DEV/tests_manuels.md : gate 1b retiré (validé) ; tests manuels phase 5 ajoutés (lisibilité
  instruments cockpit, conflit de visibilité de la coque à trancher).
- DEV/roadmap_dev.md : sous-phase 1b marquée [FAIT], dossier `shaders/` documenté.

### Notes
- Phase 1 reste en cours : 1c (nuages) et 1d (halo) restent à livrer.
- Conflit ouvert entre `roadmap_dev.md` phase 5 et le handoff design D4 sur la visibilité de la
  coque depuis le cockpit — à trancher avant l'ouverture de la phase 5.

## v0.9 — 2026-08-01

### Ajouté
- DESIGN/interieur/ : planches intérieur sous coupole (plan, coupe), volet blindé fermé/ouvert,
  palette intérieure chiffrée dans `charte.md` (Phase D3).
- DESIGN/instruments/ : console avant, écran central et cadran (set minimal générique), palette
  chiffrée dans `charte.md` (Phase D4).

### Corrigé
- DESIGN/vaisseau/proportions.md : § Statut reflète désormais la validation utilisateur du
  2026-07-31 (non mise à jour lors de la clôture D2).

### Notes
- Handoffs D3 et D4 envoyés vers `dev` (phases 4 centre de commande, 5 cockpit).
- Phase D5 (passe visuelle finale) non démarrée : dépend d'un rendu `dev` en situation.

## v0.8 — 2026-08-01

### Modifié
- DEV/tests_manuels.md : contrôle visuel gate 1a validé par l'utilisateur, section retirée ; test
  manuel phase 4 (lisibilité de l'armature de coupole) ajouté suite handoff design D2.

### Notes
- Phase 1a intégralement close (tests, couverture, contrôle visuel).
- Écarts relevés sur handoff design D2 (position panneaux solaires, statut `proportions.md` non
  mis à jour, chevauchement coupole/panneaux) signalés, non résolus — à trancher avant phase 3.
- Sous-phase 1b (shader jour/nuit) à traiter en session Opus, pas Sonnet.

## v0.7 — 2026-07-31

### Ajouté
- Phase 1a dev (géométrie et échelle, sans shader) : `scripts/core/world_scale.gd` (échelle
  unique du projet, RefCounted statique), 14 tests unitaires, couverture 100%.
- scenes/terre.tscn, lune.tscn, soleil.tscn, test_env.tscn : environnement spatial de base,
  caméra libre de debug.

### Modifié
- project.godot : import textures forcé en BPTC + mipmaps ([importer_defaults]), VRAM albédo
  Terre 939 Mo -> 354 Mo.
- DEV/roadmap_dev.md : Phase 0 [FAIT] (gate 3 validé), Phase 1 [EN COURS] ; piège GdUnit4
  (crash si `class_name` non enregistré avant `--import`) documenté.
- DEV/tests_manuels.md : contrôle visuel gate 0 retiré (validé), contrôle visuel gate 1a ajouté.

## v0.6 — 2026-07-31

### Ajouté
- DESIGN/vaisseau/proportions.md : dimensionnement chiffré du vaisseau (coque, coupole, cockpit,
  structures externes, armature), validé par l'utilisateur.
- DESIGN/vaisseau/vue_face.svg, vue_cote.svg, vue_dessus.svg : planches de forme, schémas
  techniques cotés.

### Modifié
- DESIGN/roadmap_design.md : Phase D2 marquée [FAIT], Phase D3 [EN COURS].
- DESIGN/MANIFEST.md, DESIGN/_handoff.md : mis à jour, handoff Phase D2 envoyé vers `dev`.

## v0.5 — 2026-07-31

### Ajouté
- DESIGN/charte.md, SOURCES.md, MANIFEST.md, tests_manuels.md : structure et livrables des
  phases D0-D1 (direction artistique, provenance/licence des textures, inventaire).
- Textures spatiales : albédo Terre 21600x10800, nightlights 13500x6750, nuages 2048x1024
  (NASA), albédo Lune 8k et étoiles 8k (Solar System Scope, CC-BY 4.0) — reconstructibles via
  `fetch_textures.py`, non commitées.

### Modifié
- DESIGN/roadmap_design.md : Phases D0 et D1 marquées [FAIT], Phase D2 [EN COURS].

## v0.4 — 2026-07-31

### Ajouté
- run.py : lance le projet Godot depuis la racine (fenêtré ou `--headless`).

### Modifié
- .claude/CLAUDE.md, CONVENTIONS.md, roadmap_mvp.md, DESIGN/roadmap_design.md : références
  tests_manuels.md requalifiées par zone (DEV/tests_manuels.md, DESIGN/tests_manuels.md).

### Corrigé
- tools/check_scope.py : vérifie l'index git (`git diff --cached`) au lieu de l'arbre de travail
  entier, échec explicite si rien n'est stagé.

## v0.3 — 2026-07-31

### Ajouté
- Phase 0 dev : project.godot (Forward+, 1920x1080, input map), arborescence scripts/core,
  scripts/nodes, scenes, tests, addons ; GdUnit4 v6.2.0 installé et validé en headless.
- DEV/tests_manuels.md : fichier de contrôles manuels propre à la zone dev.

### Modifié
- DEV/roadmap_dev.md : commandes de référence (GdUnit4 headless, flux check_scope.py).

### Corrigé
- tools/check_scope.py identifié comme bloquant en environnement multi-zone (lit l'arbre de
  travail entier) : correction arbitrée (vérifier l'index git), passation envoyée à orchestrateur.

## v0.2 — 2026-07-31

### Ajouté
- Roadmaps de zone : DEV/roadmap_dev.md et DESIGN/roadmap_design.md, déclinaisons techniques de roadmap_mvp.md.
- CONVENTIONS.md : périmètres d'écriture, économie de tokens, protocole de passation, objectif de tests, nommage.
- Outillage tools/ : handoff.py (passation presse-papier), coverage_check.py (couverture fonctionnelle 85%), check_scope.py (contrôle de périmètre), fetch_textures.py (reconstruction des textures NASA hors dépôt).
- .gitignore : DESIGN/textures/ exclu du dépôt.

### Modifié
- roadmap_mvp.md : phase 1 découpée en 1a-1d pour isoler le risque du shader Terre, contrainte cockpit/vaisseau invisible levée, coupole sans verre côté intérieur, mesh du vaisseau arbitré (design fixe la forme, dev produit le mesh).

## v0.1 — 2026-07-31

### Ajouté
- Roadmap MVP (roadmap_mvp.md) : 7 phases, décisions cadrantes (orbite basse ~400 km, pas de pilotage, temps réglable, volet rétractable sur la coupole, textures NASA réelles, assets dans DESIGN/).
- Zones agents `dev` (DEV/) et `design` (DESIGN/), avec `agent_role.md` et `_contexte/` dédiés.
- README.md et CHANGELOG.md initiaux.
