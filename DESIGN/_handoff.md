# Handoff — Phase D1 (Textures spatiales) → dev phase 1 (environnement)

## Livrables
Voir `DESIGN/MANIFEST.md` pour l'inventaire complet et `DESIGN/SOURCES.md` pour la reconstruction
(`python tools/fetch_textures.py`, dossier `DESIGN/textures/` non committé).

- `terre_albedo_21600x10800.jpg` — albédo jour, format Godot direct
- `terre_nightlights_13500x6750.jpg` — lumières nocturnes
- `terre_clouds_2048x1024.jpg` — masque de gris (pas d'alpha réel dans le fichier), à utiliser
  comme alpha map en shader
- `lune_albedo_8k.jpg`
- `etoiles_8k.jpg`

## Écarts au périmètre initial
- Relief/normal de la Terre retiré : aucune source NASA en téléchargement direct trouvée.
  Non bloquant pour l'environnement de base.
- Couche nuageuse en 2048x1024 seulement (résolution NASA officielle la plus haute disponible en
  téléchargement direct), très inférieure à l'albédo. À traiter comme masque, pas comme texture
  couleur.

## Licence
Toutes les textures Terre/nuit/nuages sont NASA (domaine public, crédit NASA obligatoire, pas
d'usage impliquant un endossement NASA). Lune et étoiles sont Solar System Scope, CC-BY 4.0.

## Test manuel à ajouter dans `DEV/tests_manuels.md`
- « L'albédo jour ouvert à 100 % reste net, aucun flou de suréchantillonnage. »
