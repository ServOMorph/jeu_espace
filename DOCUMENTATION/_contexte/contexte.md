# Contexte — documentation

## Objectif (immuable sauf décision explicite)
Expert en documentation de projet : garant de la cohérence, de la clarté et de l'exactitude
de la documentation du projet (roadmaps, conventions, chartes, docs de zone) — signale les
désynchronisations entre documentation et état réel du code/des assets.

## Stack / contraintes techniques (stable, rarement modifié)
Projet Godot 4.5 (jeu spatial 3D). Documentation entièrement en Markdown, répartie par zone
à rôle (`orchestrateur` racine, `DEV/`, `DESIGN/`) : roadmaps de zone (`roadmap_mvp.md`,
`DEV/roadmap_dev.md`, `DESIGN/roadmap_design.md`), conventions communes (`CONVENTIONS.md`),
chartes d'agent (`agent_role.md`), tests manuels par zone (`tests_manuels.md`). Protocole
vibecoding : `_contexte/` par zone, passation inter-agents via `tools/handoff.py`.

## État actuel (réécrit intégralement à chaque /close)
`systeme_solaire/` créé : base de connaissance de 25 objets (Soleil, 8 planètes, 5 planètes
naines, 12 lunes majeures), gabarit commun `TEMPLATE.md`, catalogue `INDEX.md`.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026-08-11 : Initialisation du protocole vibecoding (agent DOCUMENTATION, créé via /create_agent).
- 2026-08-11 : Périmètre `systeme_solaire/` fixé à 25 objets (Soleil, 8 planètes, 5 planètes
  naines majeures, 12 lunes majeures des géantes + Lune terrestre), sur demande explicite
  utilisateur ("max de données"), au-delà des 3 objets réellement présents dans le jeu
  (Terre, Soleil, Lune). Sert de base de connaissance, pas de spec d'implémentation.
