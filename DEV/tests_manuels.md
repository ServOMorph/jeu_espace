# Tests manuels — dev

## Phase 4 — Centre de commande et volet de coupole

Lancer `scenes/test_env.tscn` (scène de debug, caméra du centre de commande câblée sur
`VueOrbitale` à la place de `CameraLibre` pour ce contrôle) :
```
D:\Godot\godot.exe --path . scenes/test_env.tscn
```

- Rotation 360° à la souris depuis le poste du centre de commande : fluide, sans clipping
  ni disparition de la Terre.
- Volet fermé au démarrage (`toggle_volet`, touche V) : aucune vue vers l'extérieur.
- `toggle_volet` : ouverture progressive des 12 panneaux vers l'anneau de base, extérieur
  (coque, espace) visible entre les montants une fois ouvert.
- Inversion du volet en cours d'animation (retoucher `toggle_volet` avant la fin) : pas de
  saut visuel, le mouvement repart en sens inverse depuis la position courante.
- Coque et structures externes visibles depuis le poste (armature de coupole non pleine).
- Aucune surface de verre visible depuis l'intérieur de la coupole.