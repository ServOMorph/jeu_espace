# Roadmap DEV — implémentation Godot

Déclinaison de `roadmap_mvp.md` limitée au périmètre `dev` : `DEV/`, `scripts/`, `scenes/`,
`tests/`, `addons/`, `project.godot`, `.gitignore`.

Lire `CONVENTIONS.md` une fois en début de session (périmètres, économie de tokens, passation,
tests, nommage). Ne pas le relire ensuite. Les assets viennent de `DESIGN/` et sont importés via
`res://DESIGN/...` — jamais recopiés.

## Contraintes techniques fixées
- Godot 4.5 stable, `D:\Godot\godot.exe`, renderer Forward+.
- 1920x1080 fenêtré, caméra à la souris.
- Pas de pilotage : orbite sur rail paramétrée, monde à échelle réduite.
- Orbite basse ~400 km, période ~90 min, horloge de simulation découplée (x1/x10/x60).
- Aucun dossier `assets/` à la racine.

## Architecture imposée (conséquence de l'objectif 85 %)
```
scripts/core/    logique pure, RefCounted, aucune dependance SceneTree/nœud/_process — TESTEE
scripts/nodes/   cablage uniquement : lire entree -> appeler core -> appliquer sur le nœud
scenes/          .tscn
tests/           test_<module>.gd, un par module de core/
```
Aucune décision, aucun calcul, aucune règle métier dans `scripts/nodes/`. Si une logique est
dure à tester, elle est au mauvais endroit : la déplacer dans `core/`, ne pas la contourner.

## Dépendances envers `design`
| Phase dev | Attendu, livré dans `DESIGN/` | Fourni par |
|---|---|---|
| 1 | `DESIGN/SOURCES.md` complet — les textures s'obtiennent avec `python tools/fetch_textures.py`, elles ne sont pas dans git | design D1 |
| 3 | `DESIGN/vaisseau/proportions.md` (chiffré) | design D2 |
| 4 | planches intérieur + volet ouvert/fermé | design D3 |
| 5 | planches d'instruments 2D | design D4 |

Lire `DESIGN/MANIFEST.md` pour savoir ce qui est livré — **ne pas parcourir l'arborescence
`DESIGN/`**. Une phase ne démarre pas sans sa dépendance ; en cas de retard, travailler sur
placeholder explicitement nommé `placeholder_*`, jamais figé dans le code.

## Demander quelque chose à `design`
Écrire le prompt dans `DEV/_handoff.md`, puis :
```
python tools/handoff.py --to design --file DEV/_handoff.md
```
et annoncer en dernière ligne de la réponse : **📋 ✅ Prompt copié dans le presse-papier.**
Ne jamais l'annoncer si le script n'a pas retourné 0.

## Commandes de référence

Tests unitaires (GdUnit4 refuse le mode headless sans `--ignoreHeadlessMode` et sort en 103) :
```
D:\Godot\godot.exe --headless --path . -s addons/gdUnit4/bin/GdUnitCmdTool.gd --ignoreHeadlessMode -a tests
```

Avant chaque commit — `check_scope.py` vérifie l'index, pas l'arbre de travail. Stager d'abord,
sinon le script échoue sur les fichiers en cours des autres zones :
```
git add <fichiers de la zone>
python tools/check_scope.py dev
```

Contrôles manuels : `DEV/tests_manuels.md` (un fichier par zone, cf. CONVENTIONS.md §5).

---

## Phase 0 — Fondations du projet Godot  [EN COURS]

- `project.godot` : Godot 4.5, renderer Forward+, nom de projet, scène principale déclarée.
- Fenêtre : `display/window/size/viewport_width=1920`, `viewport_height=1080`, mode fenêtré,
  `stretch/mode=canvas_items`, `stretch/aspect=keep`.
- Arborescence : `scripts/core/`, `scripts/nodes/`, `scenes/`, `tests/`. Rien d'autre.
- `.gitignore` Godot : `.godot/`, `.import/`, `export_presets.cfg`, dossiers d'export.
- Installer GdUnit4 dans `addons/` et vérifier qu'un test trivial passe en headless. Le faire
  maintenant : l'installer en phase 2 sous pression de livraison est le scénario où les tests
  sautent.
- Input map (noms d'actions figés ici, réutilisés dans toutes les phases, ne plus les renommer) :
  - `cam_look` (souris relative, traitée en `_input`, pas d'action déclarée)
  - `toggle_lieu` — bascule cockpit / centre de commande
  - `toggle_volet` — volet de coupole
  - `time_x1`, `time_x10`, `time_x60` — multiplicateur de temps
  - `quit`
- `scenes/main.tscn` : `Node3D` racine + `Camera3D`, script `scripts/nodes/main.gd` sans logique,
  se lance sans erreur ni warning.

**Gate**
1. `D:\Godot\godot.exe --headless --path . --quit` retourne 0, sortie sans erreur.
2. Le test trivial GdUnit4 passe en headless.
3. Lancement fenêtré à 1920x1080 vérifié à l'œil, entrée ajoutée à `DEV/tests_manuels.md`.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase 1 — Intégration de l'environnement spatial  [TODO]

Dépend de design D1. Les textures **ne sont pas dans git** : les obtenir avec
`python tools/fetch_textures.py` avant de commencer. Démarrer dès que l'albédo jour et le fond
étoilé figurent dans `DESIGN/MANIFEST.md`.

Phase découpée en quatre sous-phases pour isoler le risque. **Ne pas les fusionner** : le
découpage existe précisément pour que l'échec du shader ne remette pas en cause l'échelle.

### 1a — Géométrie et échelle, sans shader
- `scripts/core/world_scale.gd` — constantes d'échelle (facteur km → unité Godot, rayon
  terrestre, altitude orbitale) et conversions. Exposé en autoload. **Aucune valeur d'échelle
  en dur ailleurs dans le projet** — c'est la source d'incohérences la plus fréquente.
- `scenes/terre.tscn` — sphère haute subdivision (assez fine pour que la courbure reste lisse
  vue de 400 km), `StandardMaterial3D` avec l'albédo jour seul.
- `scenes/soleil.tscn` — `DirectionalLight3D` + disque émissif aligné sur sa direction.
- `scenes/lune.tscn` — sphère texturée, taille apparente et distance crédibles à l'échelle.
- Fond étoilé : `WorldEnvironment` + `Sky`.
- `scenes/test_env.tscn` — scène de test à caméra libre, exclue du build final.

Gate 1a : tests unitaires sur `world_scale` (conversions aller-retour, valeurs limites),
couverture ≥ 85 %, et à l'œil depuis 400 km : courbure crédible, pas de facettage visible.

### 1b — Shader jour/nuit  [risque élevé]
- Matériau Terre : **shader personnalisé**, pas `StandardMaterial3D` — le mélange jour/nuit
  selon l'incidence de la lumière n'est pas exprimable autrement. Entrées : albédo, lumières
  nocturnes, normal map.
- **Sous-phase à traiter en session Opus**, pas Sonnet. Décision du 2026-07-31 : c'est le seul
  point du projet où l'écart de modèle change l'issue.

Gate 1b : terminateur jour/nuit net, transition progressive et non abrupte, lumières urbaines
visibles côté nuit uniquement.

### 1c — Couche nuageuse
- Sphère légèrement plus grande, texture alpha, rotation propre lente.

Gate 1c : nuages lisibles, pas de scintillement au bord, ombre portée non requise au MVP.

### 1d — Halo atmosphérique et vérification du tri
- Sphère englobante en shader, épaisseur visible par la tranche.
- **Test de tri de rendu à faire ici, pas en phase 4** : placer temporairement une sphère
  transparente factice entre la caméra et la Terre, vérifier l'ordre avec le halo et les
  nuages. C'est la phase la moins coûteuse pour découvrir un problème d'ordre de rendu.

Gate 1d : halo visible par la tranche, aucune inversion d'ordre entre halo, nuages et sphère
factice. Contrôle visuel dans `DEV/tests_manuels.md`. Retirer la sphère factice avant de clôturer.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase 2 — Horloge de simulation et orbite sur rail  [TODO]

L'horloge vient avant l'orbite : sans elle, rien n'est observable en temps raisonnable.
C'est la phase la plus testable du projet — elle doit tirer la couverture vers le haut.

- `scripts/core/sim_clock.gd` — temps simulé accumulé indépendamment du temps réel,
  multiplicateur x1/x10/x60. Le changement de multiplicateur ne doit provoquer ni saut ni
  dérive : **accumuler en secondes simulées**, ne jamais recalculer depuis un instant de
  départ multiplié. `scripts/nodes/sim_clock_node.gd` se contente de brancher `_process` et
  les entrées clavier dessus.
- `scripts/core/orbit.gd` — `position_at(t)` pure : altitude, période, inclinaison, phase de
  départ en paramètres. Aucune référence à un nœud.
- `scripts/core/sun_direction.gd` — direction du Soleil dérivée du temps simulé, cohérente
  avec la rotation propre de la Terre.
- Rotation propre de la Terre pilotée par la même horloge.
- Instant de départ choisi pour que le joueur commence de jour.

**Gate**
1. Tests unitaires : `orbit` (périodicité, altitude constante, effet de l'inclinaison, phase de
   départ), `sim_clock` (absence de dérive après N changements de multiplicateur, monotonie),
   `sun_direction` (cohérence avec la rotation terrestre sur une période complète).
2. `python tools/coverage_check.py` ≥ 85 %.
3. Une orbite complète observée en x60, transition jour/nuit visible.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase 3 — Vaisseau et hiérarchie de scène  [TODO]

Dépend de design D2 (`DESIGN/vaisseau/proportions.md`). Ne pas modéliser sans ce fichier.

Arbitrage à faire en **ouverture** de phase, une fois la forme connue :
- assemblage `.tscn` (primitives / CSG) — simple, limité aux formes que les primitives couvrent ;
- générateur `.obj` scripté en Python dans `tools/` — formes libres et reproductibles, coût
  d'écriture supérieur. À retenir dès que la forme sort du répertoire des primitives.

Livrables :
- `scenes/vaisseau.tscn` — coque low poly, armature de coupole, section cockpit.
- Matériaux : coque opaque. Le verre de la coupole est une surface **orientée vers l'extérieur
  uniquement**, présente pour la vue externe de cette phase. Aucune surface de verre n'est
  visible depuis l'intérieur (cf. phase 4) : la modéliser en `cull_back` et ne pas l'inclure
  dans la scène du centre de commande.
- Hiérarchie : `Vaisseau` parent, `Cockpit` et `CentreCommande` enfants. **Aucun code de
  synchronisation de position** — la hiérarchie fait le travail.
- `scripts/nodes/vaisseau.gd` — câblage au rail orbital de la phase 2, orientation tangente
  calculée dans `scripts/core/orbit.gd` (`tangent_at(t)`), pas dans le nœud.

**Gate**
1. Test unitaire sur `orbit.tangent_at` (orthogonalité au rayon, continuité sur une période).
2. `python tools/coverage_check.py` ≥ 85 %.
3. Depuis une caméra externe : le vaisseau suit l'orbite, éclairage cohérent, coupole distincte
   de la coque. Contrôle visuel dans `DEV/tests_manuels.md`.

> Dette à évaluer en fin de phase : couplage orbite/vaisseau et profondeur de hiérarchie.
> Décider au vu du code réel, pas par principe.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase 4 — Centre de commande et volet de coupole  [TODO]

Dépend de design D3.

- `scenes/centre_commande.tscn` — sol, structure, mobilier minimal, **armature de coupole
  opaque**.
- **Aucune surface de verre dans cette scène** (décision du 2026-07-31). Vue de l'intérieur,
  une vitre parfaitement transparente est indiscernable d'une ouverture : on supprime la
  surface, donc le problème de tri de rendu disparaît au lieu d'être géré. Le verre reste sur
  la vue extérieure de la phase 3. Ne pas « rajouter juste une vitre légère » : c'est
  exactement ce que cette décision écarte.
- `scripts/core/camera_rig.gd` — état d'orientation caméra (yaw libre, pitch borné, sensibilité,
  application d'un delta souris). Pur, testable. `scripts/nodes/camera_rig_node.gd` applique le
  résultat sur la `Camera3D` et gère la capture du curseur.
- `scripts/core/volet_state.gd` — machine à états du volet (fermé / en ouverture / ouvert / en
  fermeture), progression en fonction du temps, réponse à `toggle_volet`. L'animation est dans
  le nœud, la logique d'état est ici. État conservé dans un nœud qui survit à la bascule de
  lieu. Démarrage volet fermé.
- Vérifier que la coque et les structures externes sont visibles depuis ce poste.

**Gate**
1. Tests unitaires : `camera_rig` (bornes de pitch respectées, yaw circulaire, sensibilité),
   `volet_state` (transitions complètes, inversion en cours d'animation, idempotence).
2. `python tools/coverage_check.py` ≥ 85 %.
3. Rotation 360° fluide sans clipping ni disparition de la Terre ; extérieur visible volet
   ouvert, occulté volet fermé ; état du volet préservé après aller-retour vers le cockpit.
   Contrôle visuel dans `DEV/tests_manuels.md`.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase 5 — Cockpit  [TODO]

Dépend de design D4.

- `scenes/cockpit.tscn` — console, baie vitrée frontale.
- Caméra à débattement limité (regard vers l'avant) : **réutiliser `scripts/core/camera_rig.gd`**
  avec des bornes plus serrées. Ne pas écrire un second module de caméra.
- Voir une partie de la coque depuis le cockpit est **acceptable** (décision du 2026-07-31) :
  ne pas tordre le cadrage ni la géométrie pour l'éviter, et ne pas ajouter de masquage de
  calque de rendu.
- Instruments : planches 2D de `DESIGN/instruments/`, en texture de console ou en overlay
  `CanvasLayer` selon ce qu'indique `DESIGN/MANIFEST.md`. Statiques, aucune donnée live.

**Gate**
1. Test unitaire : bornes de débattement du cockpit sur `camera_rig` (aucune valeur atteignable
   hors du cône avant).
2. `python tools/coverage_check.py` ≥ 85 %.
3. Balayage complet du débattement sans clipping ; instruments lisibles en 1920x1080.
   Contrôle visuel dans `DEV/tests_manuels.md`.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase 6 — Bascule des lieux, performance, polish  [TODO]

Appui de design D5.

- `scripts/core/lieu_state.gd` — lieu actif, orientation caméra mémorisée **par lieu**, réponse
  à `toggle_lieu`. Pur et testable. `scripts/nodes/lieu_manager.gd` active la bonne `Camera3D`
  et désactive l'autre.
- Aucun état ne fuit d'un lieu à l'autre : c'est précisément ce que le test unitaire vérifie.
- Passe de performance : coût de la Terre haute résolution et de la transparence de coupole.
  **Mesurer avant d'optimiser** (moniteur de frames Godot), noter les chiffres avant/après.
- Passe visuelle avec `design` : exposition, tonemapping, bloom éventuel sur le Soleil.
- Sortie propre sur `quit`.

**Gate**
1. Tests unitaires `lieu_state` : bascule aller-retour, conservation d'orientation par lieu,
   absence de fuite d'état.
2. `python tools/coverage_check.py` ≥ 85 % sur l'ensemble de `scripts/core/`.
3. Parcours MVP complet : lancement, une orbite observée, bascules répétées dans les deux sens,
   framerate stable. Contrôle manuel complet dans `DEV/tests_manuels.md`.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Hors périmètre dev
Production des textures et des assets 2D, direction artistique, écriture dans `DESIGN/`.
Toute demande dans ce domaine passe par une passation vers `design`.
