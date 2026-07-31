# Contexte — design

## Objectif (immuable sauf décision explicite)
Design artistique et UX du jeu : direction visuelle (vaisseau low poly, environnement extérieur réaliste), assets 2D générés via ChatGPT/Codex.

## Stack / contraintes techniques (stable, rarement modifié)
Assets 2D générés par ChatGPT via Codex. Vaisseau en low poly. Extérieur en vue réaliste : Terre, soleil, lune, espace. Centre de commande sous coupole en verre laissant voir le vaisseau et l'extérieur ; côté cockpit, le vaisseau n'est pas visible.

## État actuel (réécrit intégralement à chaque /close)
Phases D0 et D1 closes. Charte, SOURCES.md et MANIFEST.md renseignés. Textures Terre (albédo
21600x10800, nightlights 13500x6750, nuages 2048x1024), Lune (8k) et étoiles (8k) livrées et
reconstructibles via `fetch_textures.py`. Handoff D1 envoyé vers `dev`. Phase D2 (forme du
vaisseau) à démarrer.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026-07-31 : Initialisation du protocole vibecoding.
- 2026-07-31 : Relief/normal Terre retiré du périmètre D1, aucune source NASA en téléchargement
  direct trouvée.
- 2026-07-31 : Couche nuageuse Terre livrée en 2048x1024 (max NASA direct dispo), à utiliser
  comme masque de gris en shader plutôt qu'un PNG alpha.
