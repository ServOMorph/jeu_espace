# Charte — direction artistique

## Palette
- Coque du vaisseau : à définir (Phase D2)
- Intérieur centre de commande (Phase D3) :
  - Sol : `#22262B` (graphite sombre)
  - Structure porteuse / armature côté intérieur : `#3A4048` (acier mat)
  - Mobilier (console, sièges, rangements) : `#1B2129` (bleu-nuit quasi noir)
  - Accent lumineux console (écrans/voyants statiques, pas de HUD live au MVP) : `#4FD8E0` (cyan faible intensité), usage ponctuel uniquement
  - Volet blindé : `#33383E` (acier mat, identique structure), liseré de sécurité aux jointures `#C97A2E` (ambre)
  - Éclairage ambiant volet fermé : sources ponctuelles uniquement (console + liserés), pas d'éclairage général — la salle reste lisible mais sombre
  - Volet ouvert : la lumière de la Terre/du Soleil devient la source dominante, contraste fort avec l'ambiance volet fermé (effet de révélation recherché)
- Espace / fond étoilé : à définir (Phase D1)
- Instruments cockpit (Phase D4) :
  - Écran central : fond `#12161B` (opaque), cadre `#3A4048`, motif statique `#4FD8E0` à faible opacité
  - Cadrans : fond `#1B2129`, cadre `#3A4048`, aiguille et graduations `#4FD8E0`
  - Aucune donnée live (statique uniquement, pas de pilotage au MVP)

## Échelle
- Vaisseau : low poly, ordre de grandeur en triangles à définir (Phase D2)
- Terre : orbite basse ~400 km, textures haute résolution (albédo jour 16k minimum)

## Style
- Extérieur : vue réaliste (Terre, soleil, lune, espace)
- Vaisseau : low poly
- Coupole du centre de commande : armature visible, verre non modélisé côté intérieur (tri de rendu)
- Cockpit : le vaisseau n'est pas visible depuis l'intérieur
