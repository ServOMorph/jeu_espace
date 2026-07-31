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
