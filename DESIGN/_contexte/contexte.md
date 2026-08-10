# Contexte — design

## Objectif (immuable sauf décision explicite)
Design artistique et UX du jeu : direction visuelle (vaisseau low poly, environnement extérieur réaliste), assets 2D générés via ChatGPT/Codex.

## Stack / contraintes techniques (stable, rarement modifié)
Assets 2D générés par ChatGPT via Codex. Vaisseau en low poly. Extérieur en vue réaliste : Terre, soleil, lune, espace. Centre de commande sous coupole en verre laissant voir le vaisseau et l'extérieur ; côté cockpit, le vaisseau n'est pas visible.

## État actuel (réécrit intégralement à chaque /close)
Phases D0 à D4 closes. Charte, SOURCES.md, MANIFEST.md renseignés. Textures Terre/Lune/étoiles
livrées (D1). Proportions du vaisseau chiffrées et validées (D2), resynchronisées le 2026-08-11
sur le repositionnement ventral de la coupole (planches `vue_cote.svg`/`vue_face.svg` corrigées
en miroir). Intérieur sous coupole, volet blindé fermé/ouvert et palette intérieure livrés (D3).
Instruments 2D du cockpit (set minimal générique) livrés (D4). Handoffs D3 et D4 envoyés vers
`dev`. Phase D5 (passe visuelle finale) en cours : retour `dev` en situation reçu, exposition/
contraste/lisibilité nuit jugés ok, halo atmosphérique corrigé (`shaders/halo.gdshader`). Reste à
vérifier les autres critères du gate D5 et mettre `charte.md` à jour.

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
- 2026-08-01 : Pas de surface de verre vue de l'intérieur de la coupole (tri de rendu) ; l'armature
  opaque porte seule la sensation de bulle.
- 2026-08-01 : Set d'instruments cockpit limité à un minimal générique (écran + 2 cadrans +
  bandeau de voyants), aucune fonction pilotée n'existant au MVP.
- 2026-08-11 : Coupole/observatoire resynchronisés côté ventral (nadir) dans `proportions.md` et
  les planches `vue_cote.svg`/`vue_face.svg`, suite au correctif `dev` du 2026-08-04
  (Terre invisible au zénith).
- 2026-08-11 : Halo atmosphérique jugé trop uniforme en situation (D5), corrigé directement dans
  `shaders/halo.gdshader` depuis la session `design` (exception explicite, hors périmètre normal
  de la zone, autorisée par l'utilisateur plutôt qu'une passation vers `dev`).
