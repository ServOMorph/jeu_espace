## v0.20 — 2026-08-11

### Ajouté
- Zone `documentation` créée via `/create_agent` (`DOCUMENTATION/agent_role.md`, `_contexte/`,
  alias enregistré dans `.claude/zones.md`). Rôle : cohérence et exactitude de la documentation
  du projet.
- `DOCUMENTATION/systeme_solaire/` : base de connaissance de 25 objets (Soleil, 8 planètes,
  5 planètes naines majeures, 12 lunes majeures), gabarit `TEMPLATE.md`, catalogue `INDEX.md`.
  Données sourcées NASA/JPL/ESA et Wikipédia, datées par fiche. Périmètre au-delà des 3 objets
  réellement présents dans le jeu (Terre, Soleil, Lune), sur demande explicite utilisateur.
  Lacunes connues (températures, inclinaisons d'axe, physique des planètes naines éloignées)
  documentées dans `INDEX.md` plutôt qu'extrapolées.

## v0.19 — 2026-08-11

### Corrigé
- `shaders/halo.gdshader` : halo atmosphérique jugé trop uniforme en revue visuelle (phase D5,
  zone `design`). `exposant_fresnel_diffus` 1.4→2.2 (dégradé plus marqué), `intensite_nuit_min`
  0.12→0.0 (plus de halo résiduel côté nuit sans soleil), smoothstep du terminateur
  -0.3/0.3→-0.15/0.15 (transition jour/nuit plus nette). Aucun asset DESIGN concerné (effet
  procédural pur) ; correction faite directement par la zone `design`, hors périmètre normal,
  sur autorisation explicite de l'utilisateur.

## v0.18 — 2026-08-11

### Corrigé
- Vue **Drone** (`scenes/test_env.tscn`) : l'armature de l'observatoire restait visible en
  silhouette près de l'origine — Godot promeut automatiquement une autre caméra encore
  enregistrée dans le même monde 3D quand la caméra courante est désactivée, laissant parfois
  une caméra du vaisseau active par effet de cascade. Corrigé en masquant le nœud `Vaisseau`
  tant que la vue Drone est active (`scripts/nodes/selecteur_camera.gd`), indépendamment de la
  caméra effectivement promue.
- Vue Drone : la souris n'orientait pas la caméra. `LointainViewport` (SubViewport hors-écran
  composé manuellement, sans `SubViewportContainer`) ne relaie jamais `_input()` à ses enfants —
  seul le clavier fonctionnait (`Input.is_key_pressed` en polling). `scripts/nodes/camera_drone.gd`
  expose désormais des méthodes publiques (`appliquer_delta_souris`, `gerer_clic_recapture`,
  `gerer_relachement_capture`) relayées par `selecteur_camera.gd`, qui vit dans l'arbre principal
  et reçoit les événements normalement.
- 118/118 tests, aucune régression. Contrôle visuel non exécuté cette session, entrées ajoutées
  dans `DEV/tests_manuels.md`.

## v0.17 — 2026-08-11

### Corrigé
- `DESIGN/vaisseau/proportions.md` : § Coupole — observatoire resynchronisé sur le
  repositionnement ventral (nadir) déjà appliqué côté `dev` le 2026-08-04, cerclage mi-hauteur
  de l'armature corrigé pour cohérence.
- `DESIGN/vaisseau/vue_cote.svg` et `vue_face.svg` : coupole, armature et cotations repositionnées
  en miroir pour représenter le positionnement ventral.

## v0.16 — 2026-08-11

### Ajouté
- Phase 5 dev (cockpit) : `scenes/cockpit.tscn` (console, écran, cadrans, bandeau de voyants),
  `scripts/core/camera_rig.gd` étendu avec des bornes de yaw (clamp si bornes serrées, wrap
  continu sinon — aucune régression sur le 360° de l'observatoire), réutilisé pour le cockpit
  (yaw ±40°, pitch ±30°). `scenes/vaisseau.tscn` câblé (`Cockpit/Interieur`).
- Outillage de test : `python run.py` lance désormais `scenes/test_env.tscn` avec un menu de
  sélection de caméra (`scripts/nodes/selecteur_camera.gd`) — 4 vues : **Vaisseau** (orbite
  autour du vaisseau + zoom molette, `scripts/core/camera_orbite.gd`), **Observatoire**,
  **Cockpit**, **Drone** (vol libre indépendant dans le monde lointain à échelle planétaire,
  `scripts/nodes/camera_drone.gd`, déplacement factorisé dans `scripts/core/vol_libre.gd`).
  Retour au menu par **F1** depuis n'importe quelle vue. Indice « V — ouvrir/fermer la coupole »
  affiché côté Observatoire.
- 118/118 tests, couverture fonctionnelle 100 %.
- Halo atmosphérique (`shaders/halo.gdshader`) : deux termes de Fresnel superposés (liseret net
  + halo diffus plus large), atténuation côté nuit via `direction_soleil` (poussée par
  `scripts/nodes/halo.gd`) sans extinction complète. Rotation des nuages (`nuages.gd`) recalée
  sur l'horloge de simulation (`PERIODE_ROTATION_NUAGES_S`) au lieu d'une vitesse temps réel
  fixe — suit désormais x1/x10/x60. Contrôle visuel non exécuté cette session, entrée dans
  `DEV/tests_manuels.md`.

### Modifié
- Renommage complet « Centre de commande » → « Observatoire » : `scenes/centre_commande.tscn` →
  `scenes/observatoire.tscn`, nœuds, variables exportées, docs dev et design. CHANGELOG.md et
  `_contexte/` laissés intacts (historiques).
- `camera_libre.gd` → `camera_vaisseau.gd` (WASD remplacé par orbite + zoom autour du vaisseau).
- `roadmap_mvp.md` : statuts resynchronisés avec l'état réel (phases 0-4 [FAIT], 5 [EN COURS]) —
  n'avaient jamais été mis à jour depuis la création du fichier.

### Corrigé
- `Camera3D.current` n'était jamais libéré par `desactiver()` (caméras des scripts `nodes/`) :
  une caméra du monde proche (ex. Cockpit) restait "current" et son rendu s'affichait par-dessus
  la vue Drone, les deux mondes (proche/lointain) ne se démotant pas mutuellement. `desactiver()`
  libère désormais `current`, et `selecteur_camera.gd` désactive systématiquement les quatre
  contrôleurs avant chaque changement de vue.

### Notes
- Gate 3 phase 5 (contrôle visuel cockpit) non exécuté cette session — entrée dans
  `DEV/tests_manuels.md`, commande de lancement incluse.
- `DESIGN/vaisseau/proportions.md` reste désynchronisé sur la position de la coupole (« dessus »
  au lieu de « ventral ») — correction à passer côté design, non traitée cette session.

## v0.15 — 2026-08-04

### Corrigé
- `scenes/vaisseau.tscn` : coupole et centre de commande repositionnés côté ventral (nadir) au
  lieu de dorsal (zenith) — `orbit.gd::frame_at` fixe `dorsal = zenith`, donc une coupole côté
  dorsal ne pouvait jamais donner vue sur la Terre. Rotation 180° des nœuds `Coupole` et
  `CentreCommande` (transform `(-1,0,0, 0,1,0, 0,0,-1)`), aucun script modifié — `coupole_armature.gd`
  et `volet_panneaux.gd` construisent toute leur géométrie en `+Z` local. Terre visible au nadir,
  volet ouvert, validé par contrôle visuel utilisateur.

### Notes
- Sol vitré/translucide écarté comme solution alternative : relance le risque de tri de rendu
  évité en phase 1d/4, et la coque pleine du vaisseau aurait de toute façon bloqué la vue nadir
  depuis la position dorsale d'origine.
- `DESIGN/vaisseau/proportions.md` reste désynchronisé (« dessus du fuselage ») — correction hors
  périmètre dev, passation à préparer vers `design`.
- Gate 3 phase 4 non close : 4 points restent à recontrôler dans la nouvelle configuration
  (`DEV/tests_manuels.md`).

## v0.14 — 2026-08-02

### Ajouté
- Phase 4 dev (implémentée, gate visuel en attente) : `scripts/core/camera_rig.gd` (état pur
  yaw/pitch, paramétré par des vecteurs `avant`/`haut`, découplé du repère du vaisseau) et
  `scripts/core/volet_state.gd` (machine à états fermé/ouverture/ouvert/fermeture, inversion en
  cours d'animation sans saut) — 18 tests.
- `scripts/nodes/camera_rig_node.gd`, `scripts/nodes/volet_panneaux.gd` (génération procédurale
  des 12 panneaux du volet, géométrie dérivée de `CoupoleArmature`).
- `scenes/centre_commande.tscn` (sol, console, sièges, rangement, caméra), instanciée sous
  `CentreCommande` dans `vaisseau.tscn` ; `Volet` ajouté sous `Coupole`.
- `GEMINI.md` créé (miroir d'`AGENTS.md` pour l'outillage Gemini).

### Modifié
- `scripts/nodes/coupole_armature.gd` : `class_name CoupoleArmature` ajouté, pour partager ses
  constantes de géométrie avec `volet_panneaux.gd`.
- `scripts/nodes/vue_orbitale.gd` : lit `cam_locale.global_transform.orthonormalized()` au lieu
  de `.transform` — nécessaire dès qu'une caméra de jeu est imbriquée dans la hiérarchie du
  vaisseau (mise à l'échelle ×60), plus seulement une caméra sœur comme `CameraLibre`.
- `scenes/test_env.tscn` : `VueOrbitale.camera_locale_path` pointe temporairement vers la caméra
  du centre de commande (contrôle visuel phase 4), en l'absence de `lieu_state`/`lieu_manager`.
- `.claude/CLAUDE.md`, `AGENTS.md` : toute entrée `tests_manuels.md` doit inclure la commande de
  lancement du contrôle ; toute modification de `CLAUDE.md`/`AGENTS.md`/`GEMINI.md` doit être
  proposée en synchronisation aux deux autres fichiers.

### Notes
- 97/97 tests, couverture fonctionnelle 100 %. Gate visuel phase 4 non exécuté cette session —
  entrée dans `DEV/tests_manuels.md`, commande de lancement incluse.

## v0.13 — 2026-08-01

### Ajouté
- Phase 2 dev : `scripts/core/sim_clock.gd`, `orbit.gd` (`position_at`/`tangent_at`/`frame_at`),
  `sun_direction.gd` ; rotation propre de la Terre pilotée par l'horloge de simulation.
- Phase 3 dev : `scenes/vaisseau.tscn` (CSGPolygon3D spin pour la coque, conforme à
  `DESIGN/vaisseau/proportions.md`), hiérarchie `Vaisseau`/`Cockpit`/`CentreCommande`.
- `scripts/core/repere_vaisseau.gd` : conversion entre repère planétaire et repère métrique local
  du vaisseau. Rendu passé en double échelle : `scenes/monde_lointain.tscn` rendu dans un
  `SubViewport` composé en fond, vaisseau et caméra locale en unités métriques,
  `scripts/nodes/vue_orbitale.gd` reproduisant le déplacement orbital côté caméra lointaine.
- `scripts/core/eclairage.gd` : `facteur_eclipse` (ombre cylindrique portée par la Terre +
  pénombre) — l'assombrissement en orbite vient de l'occultation, pas de la direction du Soleil.
- `Orbit.phase_pour_direction` : phase de départ calculée depuis la direction du Soleil, pour
  démarrer la simulation de jour (exigence phase 2, non vérifiable avant la phase 3).

### Corrigé
- Période de rotation propre de la Terre recalée sur 5400 s (période orbitale du projet) au lieu
  du jour sidéral réel (86164 s), imperceptible même en x60.
- Vaisseau invisible au premier rendu : near plane et précision flottante incompatibles avec un
  objet à taille réelle en unités planétaires — architecture double échelle adoptée.
- Vaisseau démarrant côté nuit, puis restant éclairé en permanence sur toute l'orbite — deux bugs
  distincts, corrigés respectivement par `phase_pour_direction` et `facteur_eclipse`.

### Notes
- 79/79 tests, couverture fonctionnelle 100 %. Gates 2 et 3 validés par contrôle visuel
  utilisateur (captures d'écran, pas déduction).
- Pivot architectural à lire avant la phase 4 : `DEV/roadmap_dev.md` Phase 3, bloc « Pivot
  architectural majeur » — `camera_rig.gd` doit s'écrire dans le repère métrique local.
- Conflit toujours ouvert (P1) entre `roadmap_dev.md` phase 5 et le handoff design D4 sur la
  visibilité de la coque depuis le cockpit — à trancher avant l'ouverture de la phase 5.

## v0.12 — 2026-08-01

### Ajouté
- shaders/halo.gdshader : halo atmosphérique (glow Fresnel additif, `cull_front`), gate 1d validé
  par contrôle visuel.
- scripts/core/world_scale.gd : constante `ALTITUDE_HALO_KM` (ligne de Karman) et
  `rayon_halo_unites()`, 2 tests unitaires (tests/test_world_scale.gd).
- scripts/nodes/halo.gd, scenes/halo.tscn : câblée dans scenes/test_env.tscn.

### Modifié
- scenes/test_env.tscn : sphère factice translucide temporaire ajoutée puis retirée après
  validation du test de tri de rendu (halo / nuages / sphère factice, ordre correct).
- DEV/roadmap_dev.md : sous-phase 1d et Phase 1 marquées [FAIT].

### Notes
- Phase 1 (environnement spatial) intégralement close. Phase 2 (horloge de simulation, orbite sur
  rail) à ouvrir en prochaine session.
- Conflit toujours ouvert (P1) entre `roadmap_dev.md` phase 5 et le handoff design D4 sur la
  visibilité de la coque depuis le cockpit — à trancher avant l'ouverture de la phase 5.

## v0.11 — 2026-08-01

### Ajouté
- shaders/nuages.gdshader : couche nuageuse (alpha depuis le masque de gris livré par design),
  gate 1c validé par contrôle visuel.
- scripts/core/world_scale.gd : constante `ALTITUDE_NUAGES_KM` et `rayon_nuages_unites()`, 2
  tests unitaires (tests/test_world_scale.gd).
- scripts/nodes/nuages.gd, scenes/nuages.tscn : rotation propre lente, câblée dans
  scenes/test_env.tscn.

### Modifié
- DEV/tests_manuels.md : 3 entrées prématurées (phases 4/5, scènes inexistantes) retirées ;
  le fichier ne doit contenir que des tests exécutables immédiatement.
- DEV/roadmap_dev.md : sous-phase 1c marquée [FAIT].

### Notes
- Phase 1 reste en cours : seule 1d (halo atmosphérique) reste à livrer.
- Conflit toujours ouvert (P1) entre `roadmap_dev.md` phase 5 et le handoff design D4 sur la
  visibilité de la coque depuis le cockpit — à trancher avant l'ouverture de la phase 5.

## v0.10 — 2026-08-01

### Ajouté
- shaders/terre.gdshader : shader jour/nuit de la Terre (albédo diurne, lumières urbaines en
  émission côté nuit), gate 1b validé par contrôle visuel.
- scripts/core/eclairage.gd : logique jour/nuit pure et testable, miroir du shader ; 11 tests
  unitaires (tests/test_eclairage.gd).

### Modifié
- scenes/terre.tscn, scripts/nodes/terre.gd, scenes/test_env.tscn : Terre câblée en
  ShaderMaterial, direction du Soleil poussée depuis le nœud Soleil.
- DEV/tests_manuels.md : gate 1b retiré (validé) ; tests manuels phase 5 ajoutés (lisibilité
  instruments cockpit, conflit de visibilité de la coque à trancher).
- DEV/roadmap_dev.md : sous-phase 1b marquée [FAIT], dossier `shaders/` documenté.

### Notes
- Phase 1 reste en cours : 1c (nuages) et 1d (halo) restent à livrer.
- Conflit ouvert entre `roadmap_dev.md` phase 5 et le handoff design D4 sur la visibilité de la
  coque depuis le cockpit — à trancher avant l'ouverture de la phase 5.

## v0.9 — 2026-08-01

### Ajouté
- DESIGN/interieur/ : planches intérieur sous coupole (plan, coupe), volet blindé fermé/ouvert,
  palette intérieure chiffrée dans `charte.md` (Phase D3).
- DESIGN/instruments/ : console avant, écran central et cadran (set minimal générique), palette
  chiffrée dans `charte.md` (Phase D4).

### Corrigé
- DESIGN/vaisseau/proportions.md : § Statut reflète désormais la validation utilisateur du
  2026-07-31 (non mise à jour lors de la clôture D2).

### Notes
- Handoffs D3 et D4 envoyés vers `dev` (phases 4 centre de commande, 5 cockpit).
- Phase D5 (passe visuelle finale) non démarrée : dépend d'un rendu `dev` en situation.

## v0.8 — 2026-08-01

### Modifié
- DEV/tests_manuels.md : contrôle visuel gate 1a validé par l'utilisateur, section retirée ; test
  manuel phase 4 (lisibilité de l'armature de coupole) ajouté suite handoff design D2.

### Notes
- Phase 1a intégralement close (tests, couverture, contrôle visuel).
- Écarts relevés sur handoff design D2 (position panneaux solaires, statut `proportions.md` non
  mis à jour, chevauchement coupole/panneaux) signalés, non résolus — à trancher avant phase 3.
- Sous-phase 1b (shader jour/nuit) à traiter en session Opus, pas Sonnet.

## v0.7 — 2026-07-31

### Ajouté
- Phase 1a dev (géométrie et échelle, sans shader) : `scripts/core/world_scale.gd` (échelle
  unique du projet, RefCounted statique), 14 tests unitaires, couverture 100%.
- scenes/terre.tscn, lune.tscn, soleil.tscn, test_env.tscn : environnement spatial de base,
  caméra libre de debug.

### Modifié
- project.godot : import textures forcé en BPTC + mipmaps ([importer_defaults]), VRAM albédo
  Terre 939 Mo -> 354 Mo.
- DEV/roadmap_dev.md : Phase 0 [FAIT] (gate 3 validé), Phase 1 [EN COURS] ; piège GdUnit4
  (crash si `class_name` non enregistré avant `--import`) documenté.
- DEV/tests_manuels.md : contrôle visuel gate 0 retiré (validé), contrôle visuel gate 1a ajouté.

## v0.6 — 2026-07-31

### Ajouté
- DESIGN/vaisseau/proportions.md : dimensionnement chiffré du vaisseau (coque, coupole, cockpit,
  structures externes, armature), validé par l'utilisateur.
- DESIGN/vaisseau/vue_face.svg, vue_cote.svg, vue_dessus.svg : planches de forme, schémas
  techniques cotés.

### Modifié
- DESIGN/roadmap_design.md : Phase D2 marquée [FAIT], Phase D3 [EN COURS].
- DESIGN/MANIFEST.md, DESIGN/_handoff.md : mis à jour, handoff Phase D2 envoyé vers `dev`.

## v0.5 — 2026-07-31

### Ajouté
- DESIGN/charte.md, SOURCES.md, MANIFEST.md, tests_manuels.md : structure et livrables des
  phases D0-D1 (direction artistique, provenance/licence des textures, inventaire).
- Textures spatiales : albédo Terre 21600x10800, nightlights 13500x6750, nuages 2048x1024
  (NASA), albédo Lune 8k et étoiles 8k (Solar System Scope, CC-BY 4.0) — reconstructibles via
  `fetch_textures.py`, non commitées.

### Modifié
- DESIGN/roadmap_design.md : Phases D0 et D1 marquées [FAIT], Phase D2 [EN COURS].

## v0.4 — 2026-07-31

### Ajouté
- run.py : lance le projet Godot depuis la racine (fenêtré ou `--headless`).

### Modifié
- .claude/CLAUDE.md, CONVENTIONS.md, roadmap_mvp.md, DESIGN/roadmap_design.md : références
  tests_manuels.md requalifiées par zone (DEV/tests_manuels.md, DESIGN/tests_manuels.md).

### Corrigé
- tools/check_scope.py : vérifie l'index git (`git diff --cached`) au lieu de l'arbre de travail
  entier, échec explicite si rien n'est stagé.

## v0.3 — 2026-07-31

### Ajouté
- Phase 0 dev : project.godot (Forward+, 1920x1080, input map), arborescence scripts/core,
  scripts/nodes, scenes, tests, addons ; GdUnit4 v6.2.0 installé et validé en headless.
- DEV/tests_manuels.md : fichier de contrôles manuels propre à la zone dev.

### Modifié
- DEV/roadmap_dev.md : commandes de référence (GdUnit4 headless, flux check_scope.py).

### Corrigé
- tools/check_scope.py identifié comme bloquant en environnement multi-zone (lit l'arbre de
  travail entier) : correction arbitrée (vérifier l'index git), passation envoyée à orchestrateur.

## v0.2 — 2026-07-31

### Ajouté
- Roadmaps de zone : DEV/roadmap_dev.md et DESIGN/roadmap_design.md, déclinaisons techniques de roadmap_mvp.md.
- CONVENTIONS.md : périmètres d'écriture, économie de tokens, protocole de passation, objectif de tests, nommage.
- Outillage tools/ : handoff.py (passation presse-papier), coverage_check.py (couverture fonctionnelle 85%), check_scope.py (contrôle de périmètre), fetch_textures.py (reconstruction des textures NASA hors dépôt).
- .gitignore : DESIGN/textures/ exclu du dépôt.

### Modifié
- roadmap_mvp.md : phase 1 découpée en 1a-1d pour isoler le risque du shader Terre, contrainte cockpit/vaisseau invisible levée, coupole sans verre côté intérieur, mesh du vaisseau arbitré (design fixe la forme, dev produit le mesh).

## v0.1 — 2026-07-31

### Ajouté
- Roadmap MVP (roadmap_mvp.md) : 7 phases, décisions cadrantes (orbite basse ~400 km, pas de pilotage, temps réglable, volet rétractable sur la coupole, textures NASA réelles, assets dans DESIGN/).
- Zones agents `dev` (DEV/) et `design` (DESIGN/), avec `agent_role.md` et `_contexte/` dédiés.
- README.md et CHANGELOG.md initiaux.
