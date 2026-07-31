# Tests manuels en attente

## Phase 1a — Environnement spatial, contrôle visuel (gate 1a)

Préalable : `python tools/fetch_textures.py` (textures non committées).

Commande : `D:\Godot\godot.exe --path D:\ServOMorph\jeu_espace scenes/test_env.tscn`

Caméra de debug : ZQSD/WASD pour se déplacer, Espace/Ctrl pour monter-descendre,
Maj pour accélérer, souris pour regarder, Échap pour libérer le curseur (Échap deux fois pour
quitter). Position de départ : 400 km au-dessus de la surface.

Critères observables :
- Depuis la position de départ, la courbure de la Terre est crédible, sans facettage visible
  sur l'horizon.
- L'albédo jour observé de près reste net, aucun flou de suréchantillonnage.
- Aucun scintillement de la texture lors des mouvements de caméra (contrôle des mipmaps).
- Le fond étoilé est présent sur 360°.
- Le Soleil est visible comme un disque distinct, et le terminateur jour/nuit est visible sur
  la Terre (le côté nuit est noir : normal en phase 1a, le shader de nuit arrive en 1b).
- La Lune est visible, nettement plus petite que la Terre, à taille apparente crédible.
- Aucune erreur ni warning dans la console de sortie.
