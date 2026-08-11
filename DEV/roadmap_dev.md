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

Après tout ajout d'un `class_name`, lancer `--import` **avant** les tests : tant que la classe
n'est pas dans `.godot/global_script_class_cache.cfg`, GdUnit4 crashe au scan (signal 11) ou
annonce « No test cases found » au lieu de signaler l'erreur. Constaté en phase 1a.
```
D:\Godot\godot.exe --headless --path . --import
```

Avant chaque commit — `check_scope.py` vérifie l'index, pas l'arbre de travail. Stager d'abord,
sinon le script échoue sur les fichiers en cours des autres zones :
```
git add <fichiers de la zone>
python tools/check_scope.py dev
```

Contrôles manuels : `DEV/tests_manuels.md` (un fichier par zone, cf. CONVENTIONS.md §5).

---

## Phase 0 — Fondations du projet Godot  [FAIT]

- `project.godot` : Godot 4.5, renderer Forward+, nom de projet, scène principale déclarée.
- Fenêtre : `display/window/size/viewport_width=1920`, `viewport_height=1080`, mode fenêtré,
  `stretch/mode=canvas_items`, `stretch/aspect=keep`.
- Arborescence : `scripts/core/`, `scripts/nodes/`, `scenes/`, `tests/`. Plus `shaders/` (ajouté
  en phase 1b, décision du 2026-08-01 : un `.gdshader` ne rentre dans aucun des quatre dossiers
  initiaux, versionné séparément pour rester diffable et éditable dans l'éditeur de shader).
- `.gitignore` Godot : `.godot/`, `.import/`, `export_presets.cfg`, dossiers d'export.
- Installer GdUnit4 dans `addons/` et vérifier qu'un test trivial passe en headless. Le faire
  maintenant : l'installer en phase 2 sous pression de livraison est le scénario où les tests
  sautent.
- Input map (noms d'actions figés ici, réutilisés dans toutes les phases, ne plus les renommer) :
  - `cam_look` (souris relative, traitée en `_input`, pas d'action déclarée)
  - `toggle_lieu` — bascule cockpit / observatoire
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

## Phase 1 — Intégration de l'environnement spatial  [FAIT]

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

### 1b — Shader jour/nuit  [FAIT]
- Matériau Terre : **shader personnalisé** (`shaders/terre.gdshader`), pas `StandardMaterial3D`.
  Entrées : albédo, lumières nocturnes. Normal map non livrée (retirée du périmètre D1), uniform
  non ajouté tant qu'aucune source n'existe.
- Logique de facteur jour/nuit dupliquée en pur GDScript testable (`scripts/core/eclairage.gd`,
  `direction_vers_soleil`/`facteur_jour`/`facteur_nuit`) — toute modification du shader doit être
  reportée sur ce module, et inversement.
- Traité en session Opus conformément à la décision du 2026-07-31.

Gate 1b : terminateur jour/nuit net, transition progressive et non abrupte, lumières urbaines
visibles côté nuit uniquement. **Validé par contrôle visuel utilisateur le 2026-08-01.**

### 1c — Couche nuageuse  [FAIT]
- Sphère légèrement plus grande, texture alpha, rotation propre lente.
- `shaders/nuages.gdshader` : alpha depuis le masque de gris `terre_clouds_2048x1024.jpg` (canal
  rouge, pas d'alpha réel dans le fichier livré). Rayon dérivé de `WorldScale.rayon_nuages_unites()`
  (constante `ALTITUDE_NUAGES_KM` ajoutée à `world_scale.gd`, aucune valeur en dur).

Gate 1c : nuages lisibles, pas de scintillement au bord, ombre portée non requise au MVP.
**Validé par contrôle visuel utilisateur le 2026-08-01.**

### 1d — Halo atmosphérique et vérification du tri  [FAIT]
- Sphère englobante en shader, épaisseur visible par la tranche.
- **Test de tri de rendu à faire ici, pas en phase 4** : placer temporairement une sphère
  transparente factice entre la caméra et la Terre, vérifier l'ordre avec le halo et les
  nuages. C'est la phase la moins coûteuse pour découvrir un problème d'ordre de rendu.

Gate 1d : halo visible par la tranche, aucune inversion d'ordre entre halo, nuages et sphère
factice. Contrôle visuel dans `DEV/tests_manuels.md`. Retirer la sphère factice avant de clôturer.
**Validé par contrôle visuel utilisateur le 2026-08-01** ; sphère factice retirée de
`scenes/test_env.tscn` après validation.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase 2 — Horloge de simulation et orbite sur rail  [FAIT]

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

**Livré** (2026-08-01) : `sim_clock.gd`/`sim_clock_node.gd`, `orbit.gd` (`position_at`/`tangent_at`),
`sun_direction.gd`, rotation propre de la Terre pilotée par l'horloge. 49/49 tests, couverture
100 %. Bug de pacing découvert au contrôle visuel : la période de rotation terrestre était calée
sur le jour sidéral réel (86164 s), imperceptible même en x60 — recalée sur 5400 s (~90 min,
période orbitale de référence du projet). `PERIODE_ROTATION_TERRE_S` documente ce choix.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase 3 — Vaisseau et hiérarchie de scène  [FAIT]

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
  dans la scène de l'observatoire.
- Hiérarchie : `Vaisseau` parent, `Cockpit` et `Observatoire` enfants. **Aucun code de
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

**Livré** (2026-08-01) : arbitrage retenu = assemblage `.tscn` (CSGPolygon3D en mode spin pour la
coque effilée, primitives Godot pour le reste) — aucune forme du chiffrage D2 ne sortait du
répertoire des primitives/CSG. `scenes/vaisseau.tscn` conforme à `proportions.md`, hiérarchie
`Vaisseau` → `Cockpit`/`Observatoire` en place.

**Pivot architectural majeur, à connaître avant d'ouvrir la phase 4** : un vaisseau à taille
réelle (~60 m) est ininterprétable dans le système d'unités planétaire du projet (1 unité =
100 km) — near plane et précision flottante le rendent invisible ou tremblant. Rendu passé en
**double échelle, deux caméras/deux viewports composités** :
- `scenes/monde_lointain.tscn` (Terre, Lune, Soleil, ciel) reste en unités planétaires, rendu
  dans un `SubViewport` (`LointainViewport`) composé en fond via `CanvasLayer`.
- Le vaisseau et sa caméra locale (`scripts/nodes/camera_libre.gd`) sont en unités métriques
  (1 unité = 1 m), **le vaisseau reste fixe à l'origine locale** — c'est la caméra lointaine qui
  reproduit son déplacement orbital (`scripts/nodes/vue_orbitale.gd`, câblé sur `Orbit.frame_at`,
  pas `vaisseau.gd`). Conversion entre repères : `scripts/core/repere_vaisseau.gd`.
- Conséquence directe pour la phase 4 : `camera_rig.gd`/`camera_rig_node.gd` opéreront dans le
  repère métrique local, pas planétaire. Le clivage « aucun code de synchronisation de position »
  reste vrai *à l'intérieur* d'un repère, mais la synchronisation *entre* les deux repères
  (`RepereVaisseau.transform_camera_lointaine`) est nécessairement du câblage explicite.
- Limite assumée : le lointain composé en fond ne partage pas le z-buffer du proche (la Terre ne
  peut jamais occulter le vaisseau). Sans effet une fois la caméra à bord (phases 4-5), pertinent
  seulement pour une caméra externe libre — non testable en pratique avec les plans de coupure
  actuels et retiré des tests manuels pour cette raison.

Bug corrigé au contrôle visuel : le vaisseau démarrait côté nuit (exigence « démarrer de jour »
de la phase 2, non vérifiable avant l'existence d'un vaisseau) — `Orbit.phase_pour_direction`
ajouté, calcule la phase de départ depuis la direction du Soleil. Second bug : la lumière locale
du vaisseau était orientée mais jamais éteinte par l'ombre de la Terre — `Eclairage.facteur_eclipse`
ajouté (ombre cylindrique + pénombre), câblé dans `vue_orbitale.gd`. 79/79 tests, couverture 100 %.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase 4 — Observatoire et volet de coupole  [FAIT]

Dépend de design D3.

Lire le bloc « Pivot architectural majeur » en fin de phase 3 avant d'écrire `camera_rig.gd` :
la caméra de jeu opère dans le repère métrique local du vaisseau (`RepereVaisseau`), pas en
unités planétaires.

- `scenes/observatoire.tscn` — sol, structure, mobilier minimal, **armature de coupole
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

**État (2026-08-02)** : gates 1 et 2 validés — 97/97 tests, couverture 100 %. Gate 3 (contrôle
visuel) en attente, entrée dans `DEV/tests_manuels.md`. Caméra de l'observatoire câblée
temporairement dans `test_env.tscn` (`VueOrbitale.camera_locale_path`) pour ce contrôle, en
l'absence de `lieu_state`/`lieu_manager` (phase 6). `vue_orbitale.gd` adapté pour lire
`global_transform.orthonormalized()` : nécessaire dès qu'une caméra est imbriquée dans la
hiérarchie du vaisseau (mise à l'échelle ×60), plus seulement une caméra sœur.

**État (2026-08-04)** : bug trouvé au contrôle visuel — la Terre restait invisible depuis
l'observatoire quelle que soit la rotation. Cause : `orbit.gd::frame_at` fixe
`dorsal = zenith` (direction opposée à la Terre) ; la coupole, placée « dessus du fuselage » par
`DESIGN/vaisseau/proportions.md`, n'ouvrait donc que sur l'espace/zénith. Corrigé en repositionnant
la coupole et l'observatoire côté ventral (nadir) : rotation 180° des nœuds `Coupole` et
`Observatoire` dans `scenes/vaisseau.tscn`, aucun script modifié (armature et volet construits
en `+Z` local, sans référence au monde). Terre visible au nadir, validé par contrôle visuel.
`DESIGN/vaisseau/proportions.md` reste à corriger côté design (toujours « dessus »).

**Gate 3 validé** (contrôle visuel utilisateur) : rotation 360° fluide sans clipping ni
disparition de la Terre, volet réversible en cours d'animation sans saut, coque et structures
externes visibles, aucune surface de verre visible depuis l'intérieur de la coupole.

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

**État (2026-08-10)** : gates 1 et 2 validés — `scripts/core/camera_rig.gd` étendu avec des
bornes de yaw (clamp si bornes < cercle complet, wrap continu sinon — aucune régression sur le
360° de l'observatoire), réutilisé tel quel pour `scenes/cockpit.tscn` (yaw ±40°, pitch
±30°). 101/101 tests, couverture 100 %. `scenes/vaisseau.tscn` câblé (`Cockpit/Interieur`).
Gate 3 (contrôle visuel) en attente, entrée dans `DEV/tests_manuels.md`.

**Ajout de périmètre (2026-08-11, décision orchestrateur, cf. `roadmap_mvp.md` Phase 5)** :
tableau de bord du cockpit à construire, caméra inchangée (fixe, bornes déjà en place) :
- Deux baies vitrées frontales avec vue sur l'espace (le rendu du monde lointain existant suffit,
  pas de nouvelle géométrie de vue).
- Deux écrans : `IA` et `MAP`, rendu procédural (shader ou dessin vectoriel en `CanvasLayer`),
  esthétique soignée type Star Wars (contours nets, glow, palette sombre/contrastée) — pas de
  planche 2D `design`, ce périmètre reste dans `dev`.
- Clic sur l'écran MAP : ouvre un overlay plein cadre qui dessine la position relative de la
  Terre, de la Lune et du Soleil, dérivée de l'état orbital réel (`orbit.gd`, `sun_direction.gd`
  côté `scripts/core/`, aucune valeur en dur). C'est la seule donnée live du cockpit — le reste
  des instruments (écran IA compris) reste statique, conformément à la contrainte d'origine.
- Toute logique de calcul de position (projection sur la carte) doit vivre en `scripts/core/`,
  pure et testable, au même titre que le reste de l'architecture imposée.

**Pivot (2026-08-11, même session, plan utilisateur)** : la disposition ci-dessus (deux écrans
IA/MAP, clic pour ouvrir un overlay plein cadre) est remplacée par un plan fourni par
l'utilisateur — vue extérieure (baie vitrée existante, inchangée) en partie haute, rangée de
trois écrans en dessous. Écran 1 affiche la carte Terre/Lune/Soleil **en permanence** (plus de
clic ni d'overlay) ; écrans 2 et 3 sont des placeholders statiques, contenu à définir plus tard.
Livré : `scripts/core/cockpit_map.gd` (projection azimutale équidistante, testé), `scenes/
ecran_holo.tscn` (écran procédural réutilisable, style cadre net/glow/palette sombre, sert aux
placeholders), `scenes/ecran_map_3d.tscn` + `carte_map_driver.gd` (écran 1, mis à jour en
continu depuis `orbit.gd`/`sun_direction.gd`). Le mécanisme de clic/overlay initialement
implémenté (`ciblage_ecran.gd`, `cockpit_interaction.gd`, `reticule_cockpit.gd`,
`carte_overlay.gd`) a été retiré, devenu inutile. 127/127 tests, couverture `scripts/core/`
100 %. Instruments existants (cadrans, bandeau, ancien écran central) conservés tels quels.
Gate 3 (contrôle visuel) toujours en attente, entrée mise à jour dans `DEV/tests_manuels.md` —
disposition géométrique de la nouvelle rangée non vérifiée à l'œil.

Outillage ajouté à cette occasion, hors périmètre gate : `python run.py` lance désormais
`scenes/test_env.tscn` avec un menu de sélection de caméra (`scripts/nodes/selecteur_camera.gd`)
— remplace l'édition manuelle de `VueOrbitale.camera_locale_path` pour choisir entre les
quatre vues (Vaisseau, Observatoire, Cockpit, Drone). `camera_rig_node.gd` gagne
`actif_au_demarrage`/`activer()`/`desactiver()` pour permettre cette activation différée ;
comportement par défaut (`actif_au_demarrage = true`) inchangé pour un usage autonome de
`observatoire.tscn`/`cockpit.tscn`.

Étoffé le 2026-08-10 (même session) : l'ancienne caméra libre (WASD) est devenue **Vaisseau**,
une caméra en orbite autour du vaisseau avec zoom molette — `scripts/core/camera_orbite.gd`
(pur, testé, même famille que `camera_rig.gd`), câblée par `scripts/nodes/camera_vaisseau.gd`
(reprend le renommage `camera_libre.gd` → `camera_vaisseau.gd`). Nouvelle vue **Drone** : vol
libre indépendant du vaisseau dans le monde lointain (échelle planétaire), pour retrouver la
vue d'ensemble de la Terre qu'on avait avant l'arrivée du vaisseau — `scripts/nodes/camera_drone.gd`,
déplacement factorisé dans `scripts/core/vol_libre.gd` (réutilisé par `camera_drone.gd`, pas
dupliqué). `selecteur_camera.gd` réactive explicitement `camera_lointaine_path.current` à
chaque changement de vue : le Drone la rend "current" à sa place le temps de son activation
(un seul monde/viewport pour la Terre), sans quoi le fond resterait figé sur le dernier point
de vue du Drone après être revenu sur Observatoire/Cockpit. 118/118 tests, couverture 100 %.

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
