# Vues — référence rapide

Les quatre points de vue disponibles via le menu de `python run.py`. Toutes coexistent
dans `scenes/test_env.tscn`, une seule est active à la fois.

## Comment tester
```
python run.py
```
Menu au démarrage → clic sur le bouton de la vue voulue. Pour revenir au menu depuis
n'importe quelle vue : **F1** (fonctionne directement, souris capturée ou non).

---

## 1. Vaisseau

| | |
|---|---|
| But | Observer le vaisseau de l'extérieur, en orbite autour de lui. Pas un point de vue du jeu final. |
| Fichier | pas de scène propre — `CameraVaisseau` dans `scenes/test_env.tscn` |
| Script | `scripts/nodes/camera_vaisseau.gd`, logique dans `scripts/core/camera_orbite.gd` |
| Cible | le vaisseau, fixe à l'origine du repère local (0,0,0) |
| Regard | souris — orbite autour de la cible, pitch borné ±89° (évite le retournement aux pôles) |
| Zoom | molette — avant rapproche, arrière éloigne ; pas multiplicatif (confortable proche comme large) |
| Distance | 120 m par défaut, bornée entre 20 m et 600 m |
| Limite connue | le fond lointain (Terre/Lune/Soleil) ne peut jamais occulter le vaisseau (deux rendus composités séparément) — visible seulement ici, sans effet en jeu |

---

## 2. Observatoire (sous coupole)

| | |
|---|---|
| But | Vue à 360° sous la coupole du vaisseau, volet occultant rétractable. |
| Fichier scène | `scenes/observatoire.tscn`, instancié dans `Vaisseau/Observatoire/Interieur` |
| Scripts | `scripts/core/camera_rig.gd` (orientation), `scripts/core/volet_state.gd` (volet) |
| Position dans le vaisseau | coupole à 0,55 L depuis l'avant, côté ventral (nadir) — diamètre 0,30 L |
| Regard | souris, **rotation complète 360°** (yaw et pitch sans limite autre que ±89°) |
| Volet | touche `toggle_volet` (V) — 12 panneaux, glissent radialement vers l'anneau de base ; état conservé au changement de vue |
| Palette | sol `#22262B`, structure `#3A4048`, mobilier `#1B2129`, accent console `#4FD8E0`, volet `#33383E` avec liseré `#C97A2E` |
| Contrainte tenue | aucune surface de verre visible depuis l'intérieur (armature opaque seulement, tri de rendu évité) |
| Statut | phase 4 — FAIT, gate visuel validé |

---

## 3. Cockpit

| | |
|---|---|
| But | Poste de pilotage avant, console d'instruments statiques (pas de pilotage au MVP). |
| Fichier scène | `scenes/cockpit.tscn`, instancié dans `Vaisseau/Cockpit/Interieur` |
| Script | `scripts/core/camera_rig.gd` (même module que l'observatoire, bornes différentes) |
| Position dans le vaisseau | section avant, proche du nez, à 0,925 L |
| Regard | souris, **borné** — yaw ±40°, pitch ±30° (cône avant uniquement, pas de vue arrière) |
| Instruments | écran central (`instrument_ecran.svg`), 2 cadrans (`instrument_cadran.svg`, transparents), bandeau de voyants — décoratifs, aucune donnée live |
| Contrainte assouplie | voir une partie de la coque depuis le cockpit est acceptable (décision du 2026-07-31) |
| Statut | phase 5 — code livré, gate visuel en attente |

---

## 4. Drone

| | |
|---|---|
| But | Vol libre autour de la planète, indépendant du vaisseau — la vue qu'on avait avant l'arrivée du vaisseau dans le projet. |
| Fichier | pas de scène propre — `CameraDrone` dans `LointainViewport`, `scenes/test_env.tscn` |
| Script | `scripts/nodes/camera_drone.gd`, déplacement factorisé dans `scripts/core/vol_libre.gd` |
| Monde | le monde lointain (échelle planétaire, `WorldScale` : 1 unité = 100 km) — pas le repère métrique du vaisseau |
| Position de départ | vue d'ensemble de la Terre, à ~2,2 rayons terrestres |
| Déplacement | Z/W avant, S arrière, Q/A gauche, D droite, Espace haut, Ctrl bas |
| Vitesse | 15 unités/s normal (1500 km/s), 150 unités/s avec Maj |
| Regard | souris, sensibilité 0.003 |
| Particularité | totalement indépendant de l'orbite du vaisseau — `vue_orbitale.gd` continue de synchroniser la caméra lointaine en arrière-plan, sans effet tant que le Drone reste actif (elle reprend la main dès qu'on choisit une autre vue) |

---

## Données communes

| | |
|---|---|
| Échelle du vaisseau | longueur totale 60 m (`RepereVaisseau.LONGUEUR_VAISSEAU_M`), modélisé en unités relatives L = 1.0 |
| Échelle planétaire | 1 unité = 100 km (`WorldScale.KM_PAR_UNITE`) |
| Orbite | altitude ~400 km, période 5400 s (90 min), inclinaison 51,6° |
| Multiplicateur de temps | touches 1 / 2 / 3 → x1 / x10 / x60 |
| Quitter | fermeture de la fenêtre (aucune caméra ne mappe `quit` à une sortie d'application) |
