# Tests manuels — dev

## Vue Drone — contrôle souris

Lancer :
```
python run.py
```
Choisir **Drone**.

- La souris oriente la caméra (regard libre autour de la Terre), en plus du déplacement
  clavier (ZQSD/WASD).
- Clic après un Échap (`quit`) recapture la souris et rend l'orientation à nouveau active.

## Vue Drone — armature du vaisseau ne doit plus apparaître

Lancer :
```
python run.py
```
Choisir **Drone** depuis le menu. Vérifier qu'aucun élément du vaisseau (armature de
coupole, coque) n'apparaît, y compris en revenant d'une autre vue (Observatoire/Cockpit)
puis en repassant sur Drone plusieurs fois de suite.

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

## Tableau de bord du cockpit — rangée de 3 écrans (Ecran1 = MAP)

Lancer :
```
python run.py
```
Choisir **Cockpit** depuis le menu.

- Vue extérieure (baie vitrée existante) inchangée devant le cockpit, aucune régression.
- Rangée de 3 écrans lisibles dans le tableau de bord, sous les instruments existants
  (cadrans, bandeau) : cadre net, glow, palette sombre/contrastée (esthétique soignée, pas
  de texture floue ni de contour baveux).
- Écran 1 (gauche) : disque radar affiché en permanence, marqueur de vaisseau au centre,
  icônes Terre/Lune/Soleil positionnées autour, aucune interaction requise.
- Écrans 2 et 3 : placeholders statiques (« ECRAN 2 » / « ECRAN 3 »), aucune donnée live.
- Temps accéléré (x60) : les icônes de l'écran 1 doivent bouger de façon cohérente avec
  l'orbite observée (la Terre reste globalement au centre si le nadir est dans l'axe du
  regard, le Soleil tourne lentement autour à mesure que l'orientation change).
- Balayage complet du débattement caméra (yaw ±40°, pitch ±30°) : les 3 écrans doivent rester
  atteignables sans sortir du cône avant ni se chevaucher avec les instruments existants.
- Overlay `MAP` ouvert, temps accéléré (x60) : les icônes Terre/Lune/Soleil doivent bouger de
  façon cohérente avec l'orbite observée (la Terre reste globalement au centre si le nadir est
  dans l'axe du regard, le Soleil tourne lentement autour à mesure que l'orientation change).

## Nouvelles caméras — Vaisseau (orbite) et Drone

- **Vaisseau** : orbite fluide autour du vaisseau dans toutes les directions (pitch borné
  ±89°, pas de retournement) ; molette avant rapproche, arrière éloigne, sans à-coup ni
  dépassement des bornes (20 m – 600 m).
- **Drone** : vol libre autour de la Terre (ZQSD/WASD + souris), indépendant du vaisseau.
  Après être passé par le Drone, revenir sur Observatoire ou Cockpit doit réafficher
  correctement le fond lointain synchronisé sur l'orbite (pas de vue figée sur le dernier
  point de vue du Drone).
