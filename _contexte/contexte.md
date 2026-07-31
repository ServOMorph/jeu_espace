# Contexte — orchestrateur

## Objectif (immuable sauf décision explicite)
Jeu spatial 3D sous Godot : le joueur pilote un vaisseau en orbite terrestre réaliste, alternant entre le cockpit (vue extérieure sur l'espace) et le centre de commande sous coupole (vue à 360°, vaisseau visible). MVP : vaisseau low poly, environnement extérieur réaliste (Terre, soleil, lune, espace).

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4 (3D). Assets 2D générés par ChatGPT via Codex. Résolution cible MVP : 1920x1080 fenêtré, contrôle caméra à la souris. 3 agents prévus : orchestrateur, codeur, design.

## État actuel (réécrit intégralement à chaque /close)
Projet initialisé. Aucun livrable produit.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026-07-31 : Initialisation du protocole vibecoding (zone racine `orchestrateur`), d'après `_DOCS/idée de base.txt`.
