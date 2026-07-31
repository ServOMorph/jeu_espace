# Signals — orchestrateur   (MAJ 2026-07-31)

## Actions ouvertes
- [P1|ouvert] Lancer /start dev pour démarrer la phase 0 (fondations projet Godot)
  fait quand: project.godot créé, fenêtre 1920x1080, scène racine qui se lance sans erreur, GdUnit4 installé et test trivial vert
  réf: DEV/roadmap_dev.md (Phase 0)
- [P2|ouvert] Renseigner DESIGN/SOURCES.md (URLs NASA réelles) et lancer tools/fetch_textures.py --record
  fait quand: python tools/fetch_textures.py retourne 0 sur DESIGN/textures/ vidé
  réf: DESIGN/roadmap_design.md (Phase D1)
- [P2|ouvert] Vérifier que la NASA propose bien un équirectangulaire 16k en un seul fichier (sinon 8k + dalles)
  fait quand: constat fait en ouverture de phase D1, noté dans DESIGN/MANIFEST.md
  réf: roadmap_mvp.md (section "Frictions résiduelles")
- [P2|ouvert] Trancher la technique de mesh du vaisseau (.tscn assemblage ou .obj scripté)
  fait quand: décision actée en ouverture de la phase 3 dev, au vu de DESIGN/vaisseau/proportions.md
  réf: DEV/roadmap_dev.md (Phase 3)

## Dernière session (2026-07-31)
<!-- Écrasé intégralement par /close. Synthèse < 25 lignes. -->
# Session du 2026-07-31

## Décisions prises
- Roadmaps de zone créées : DEV/roadmap_dev.md et DESIGN/roadmap_design.md, déclinaisons techniques de roadmap_mvp.md.
- CONVENTIONS.md créé : périmètres d'écriture, économie de tokens, protocole de passation, tests, nommage — référence commune dev/design.
- Textures NASA hors dépôt git : DESIGN/textures/ en .gitignore, reconstruites via tools/fetch_textures.py à partir de DESIGN/SOURCES.md (URL + sha256).
- Phase 1 (environnement) découpée en 1a/1b/1c/1d pour isoler le risque du shader Terre ; 1b (jour/nuit) réservée à une session Opus.
- Contrainte "vaisseau invisible depuis le cockpit" levée : voir la coque depuis le cockpit est accepté.
- Pas de surface de verre côté intérieur de la coupole (armature opaque seule) : supprime le risque de tri de rendu au lieu de le gérer.
- Passation inter-agents formalisée : tools/handoff.py copie le prompt dans le presse-papier, l'agent annonce 📋 ✅.

## Livrables produits ou modifiés
- DEV/roadmap_dev.md, DESIGN/roadmap_design.md : créés.
- CONVENTIONS.md, .gitignore : créés.
- roadmap_mvp.md : mis à jour (arbitrages, table de dépendances dev/design, frictions résiduelles).
- tools/handoff.py, tools/coverage_check.py, tools/check_scope.py, tools/fetch_textures.py : créés et testés (exécution + vérification presse-papier).

## Hypothèses validées / invalidées
- VALIDE : mesh produit par dev, forme fixée par design (proportions.md).
- VALIDE : textures hors dépôt, reconstruction scriptée.
- INVALIDE : contrainte cockpit/vaisseau invisible -> abandonnée, vaisseau visible accepté.
- EN ATTENTE : disponibilité réelle du 16k NASA en un seul fichier ; technique de mesh (.tscn vs .obj).

## Prochaine étape exacte
Lancer /start dev pour démarrer la phase 0 selon DEV/roadmap_dev.md.

## Question bloquante pour la session suivante
Aucune
