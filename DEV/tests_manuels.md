# Tests manuels — dev

## Halo atmosphérique et vitesse des nuages

Lancer :
```
python run.py
```
Choisir la vue **Vaisseau** (orbite) ou **Drone** pour observer la Terre à distance.

- Halo : liseret net à la tranche + halo diffus plus large, atténué côté nuit (pas éteint),
  contraste jour/nuit visible en tournant autour de la Terre.
- Nuages : dérive lente et cohérente avec le multiplicateur de temps (x1/x10/x60) — vérifier
  qu'ils ne semblent plus tourner à vitesse constante indépendamment du multiplicateur.

## Phase 5 — Cockpit

Lancer :
```
python run.py
```
Un menu s'affiche au démarrage (`scenes/test_env.tscn`) : cliquer sur **Cockpit**.

- Balayage complet du débattement (yaw ±40°, pitch ±30°) sans clipping ni valeur hors du cône
  avant.
- Instruments (écran central, cadrans) lisibles en 1920x1080.
- Aucun élément de coque ne doit gêner la lecture des instruments (voir une partie de la coque
  en périphérie est acceptable, cf. décision du 2026-07-31 — ne pas signaler comme un défaut).
- Retour au menu : dans chacune des quatre vues (vaisseau, observatoire, cockpit, drone),
  appuyer sur **F1** ramène directement au menu de sélection (souris capturée ou non).

## Nouvelles caméras — Vaisseau (orbite) et Drone

- **Vaisseau** : orbite fluide autour du vaisseau dans toutes les directions (pitch borné
  ±89°, pas de retournement) ; molette avant rapproche, arrière éloigne, sans à-coup ni
  dépassement des bornes (20 m – 600 m).
- **Drone** : vol libre autour de la Terre (ZQSD/WASD + souris), indépendant du vaisseau.
  Après être passé par le Drone, revenir sur Observatoire ou Cockpit doit réafficher
  correctement le fond lointain synchronisé sur l'orbite (pas de vue figée sur le dernier
  point de vue du Drone).
