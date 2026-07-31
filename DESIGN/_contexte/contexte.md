# Contexte — design

## Objectif (immuable sauf décision explicite)
Design artistique et UX du jeu : direction visuelle (vaisseau low poly, environnement extérieur réaliste), assets 2D générés via ChatGPT/Codex.

## Stack / contraintes techniques (stable, rarement modifié)
Assets 2D générés par ChatGPT via Codex. Vaisseau en low poly. Extérieur en vue réaliste : Terre, soleil, lune, espace. Centre de commande sous coupole en verre laissant voir le vaisseau et l'extérieur ; côté cockpit, le vaisseau n'est pas visible.

## État actuel (réécrit intégralement à chaque /close)
Phases D0, D1 et D2 closes. Charte, SOURCES.md, MANIFEST.md renseignés. Textures Terre/Lune/étoiles
livrées (cf. historique D1). `DESIGN/vaisseau/proportions.md` chiffré et validé, planches
`vue_face.svg`/`vue_cote.svg`/`vue_dessus.svg` livrées en schémas techniques cotés. Handoff D2
envoyé vers `dev`. Phase D3 (intérieur centre de commande + volet) à démarrer.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026-07-31 : Initialisation du protocole vibecoding.
- 2026-07-31 : Relief/normal Terre retiré du périmètre D1, aucune source NASA en téléchargement
  direct trouvée.
- 2026-07-31 : Couche nuageuse Terre livrée en 2048x1024 (max NASA direct dispo), à utiliser
  comme masque de gris en shader plutôt qu'un PNG alpha.
- 2026-07-31 : Planches de forme D2 livrées en schémas techniques SVG cotés, pas en rendu
  artistique ChatGPT/Codex (choix utilisateur en session).
- 2026-07-31 : Proportions du vaisseau (fuselage, coupole 0.30 L, cockpit 0.15 L, structures
  externes) validées par l'utilisateur sans modification.
