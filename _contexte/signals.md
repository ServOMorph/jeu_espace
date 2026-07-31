# Signals — orchestrateur   (MAJ 2026-07-31)

## Actions ouvertes
- [P1|ouvert] Lancer /start dev pour cocher le gate 3 phase 0 (validé visuellement par l'utilisateur) et clôturer la phase
  fait quand: DEV/tests_manuels.md a sa section Phase 0 supprimée, phase 0 passée [FAIT] dans DEV/roadmap_dev.md
  réf: DEV/tests_manuels.md, DEV/roadmap_dev.md (Phase 0)
- [P1|ouvert] Lancer /start design pour démarrer D0 (structure + charte)
  fait quand: DESIGN/charte.md rempli, arborescence DESIGN/ créée, MANIFEST.md formaté
  réf: DESIGN/roadmap_design.md (Phase D0)
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
- Handoff dev traité : tools/check_scope.py lit désormais l'index seul (git diff --cached), échec explicite si rien n'est stagé.
- tests_manuels.md confirmé par zone (DEV/, DESIGN/), requalifié dans .claude/CLAUDE.md, CONVENTIONS.md §5, roadmap_mvp.md, DESIGN/roadmap_design.md.
- Gate 3 phase 0 dev (fenêtré, sans erreur) validé visuellement par l'utilisateur ; la case à cocher dans DEV/tests_manuels.md reste hors périmètre orchestrateur, reportée à une session /start dev.

## Livrables produits ou modifiés
- tools/check_scope.py : corrigé (index seul, échec sur index vide).
- .claude/CLAUDE.md, CONVENTIONS.md, roadmap_mvp.md, DESIGN/roadmap_design.md : références tests_manuels.md requalifiées par zone.
- run.py : créé à la racine, lance Godot (fenêtré ou --headless), testé.

## Hypothèses validées / invalidées
- VALIDE : correction check_scope.py testée (index vide -> échec explicite, fichiers hors périmètre détectés).
- VALIDE : gate 3 phase 0 dev, confirmé visuellement par l'utilisateur.
- EN ATTENTE : disponibilité réelle du 16k NASA en un seul fichier ; technique de mesh (.tscn vs .obj).

## Prochaine étape exacte
/start dev pour clôturer la phase 0 (cocher tests_manuels.md), puis /start design pour démarrer D0.

## Question bloquante pour la session suivante
Aucune
