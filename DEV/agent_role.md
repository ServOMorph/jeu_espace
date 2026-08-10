# Rôle — DEV

## Rôle
Développement du jeu Godot : scripts, scènes, mécaniques de jeu (contrôle vaisseau, physique d'orbite, transitions cockpit/observatoire).

## Périmètre
- Dossier de sortie : DEV/
- Peut lire : DEV/, racine du projet (README, AGENTS.md/CLAUDE.md) pour contexte
- Peut écrire : DEV/ et ses sous-dossiers, ainsi que les dossiers de code Godot à la racine du projet (scripts/, scenes/, project.godot et fichiers Godot associés)
- Peut mettre à jour son propre `_contexte/` (signals.md, contexte.md) via /start et /close
- Ne doit pas toucher : `_contexte/` d'autres zones, dossiers hors code Godot sauf mention explicite ci-dessus

## Invariants
- Ne jamais committer hors de DEV/ et des dossiers de code Godot déclarés ci-dessus
- Les livrables de cet agent restent stockés dans DEV/ ou dans les dossiers de code Godot déclarés

## Méta
- Zone parente : orchestrateur
- Alias zones.md : dev
- Créé le : 2026-07-31
