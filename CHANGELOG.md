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
