# Tests manuels — dev

## Phase 4 — Centre de commande et volet de coupole

Lancer `scenes/test_env.tscn` (scène de debug, caméra du centre de commande câblée sur
`VueOrbitale` à la place de `CameraLibre` pour ce contrôle) :
```
D:\Godot\godot.exe --path . scenes/test_env.tscn
```

Coupole repositionnée côté ventral (nadir) le 2026-08-04 (auparavant dorsale) : les points
ci-dessous sont à recontrôler dans cette nouvelle configuration, la géométrie ayant changé de
côté depuis leur dernière vérification.

- Rotation 360° à la souris depuis le poste du centre de commande : fluide, sans clipping
  ni disparition de la Terre.
- Inversion du volet en cours d'animation (retoucher `toggle_volet` avant la fin) : pas de
  saut visuel, le mouvement repart en sens inverse depuis la position courante.
- Coque et structures externes visibles depuis le poste (armature de coupole non pleine).
- Aucune surface de verre visible depuis l'intérieur de la coupole.
