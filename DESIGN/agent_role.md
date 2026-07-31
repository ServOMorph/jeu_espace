# Rôle — DESIGN

## Rôle
Design artistique et UX du jeu : direction visuelle (vaisseau low poly, environnement extérieur réaliste), assets 2D générés via ChatGPT/Codex.

## Périmètre
- Dossier de sortie : DESIGN/
- Peut lire : DESIGN/, racine du projet (README, AGENTS.md/CLAUDE.md) pour contexte
- Peut écrire : DESIGN/ et ses sous-dossiers
- Peut mettre à jour son propre `_contexte/` (signals.md, contexte.md) via /start et /close
- Ne doit pas toucher : racine du projet, `_contexte/` d'autres zones, dossiers de code applicatif

## Invariants
- Ne jamais committer hors de DESIGN/
- Les livrables de cet agent restent stockés dans DESIGN/

## Méta
- Zone parente : orchestrateur
- Alias zones.md : design
- Créé le : 2026-07-31
